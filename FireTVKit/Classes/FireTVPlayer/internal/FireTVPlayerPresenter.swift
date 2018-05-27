//
//  FireTVPlayerPresenter.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import RxSwift
import UIKit

final class FireTVPlayerPresenter: FireTVPlayerPresenterProtocol {
    private weak var view: FireTVPlayerViewProtocol?
    private let interactor: FireTVPlayerInteractorInputProtocol
    private let router: FireTVPlayerRouterProtocol
    private let dependencies: FireTVPlayerPresenterDependenciesProtocol
    private let disposeBag: DisposeBag
    private var state: FireTVPlayerPresenterState {
        didSet {
            updateUI(forState: state)
        }
    }
	private let theme: FireTVPlayerThemeProtocol
    private weak var delegate: FireTVPlayerDelegateProtocol?
    
	init(dependencies: FireTVPlayerPresenterDependenciesProtocol, view: FireTVPlayerViewProtocol, interactor: FireTVPlayerInteractorInputProtocol, router: FireTVPlayerRouterProtocol, theme: FireTVPlayerThemeProtocol, delegate: FireTVPlayerDelegateProtocol?) {
        self.dependencies = dependencies
        self.view = view
        self.interactor = interactor
        self.router = router
		self.theme = theme
        self.delegate = delegate
        
        self.disposeBag = DisposeBag()
        self.state = .disconnected
    }
    
    deinit {
        dependencies.logger.log(message: "FireTVPlayerPresenter deinit", event: .info)
    }
    
    func viewDidLoad() {
        interactor.startFireTVDiscovery()
		
		view?.setTheme(theme)
        view?.setPlayerName(interactor.getPlayerName())
        view?.setPosition(0)
        view?.setPositionText("00:00:00")
        view?.setMaximumPosition(0)
        view?.setDurationText("00:00:00")
        state = .loading
        
        interactor.connect()
            .subscribe(onCompleted: { [weak self] in
                self?.state = .connected
                self?.getDuration()
                self?.getPlayerInfo()
                self?.getPlayerData()
                self?.observePlayerData()
            }) { [weak self] error in
                self?.dependencies.logger.log(message: "interactor.connect(): \(error.localizedDescription)", event: .error)
                self?.state = .disconnected
            }.disposed(by: disposeBag)
    }
    
    func didPressCloseButton() {
        guard let viewController = view as? FireTVPlayerViewController else {
            return
        }
        
        state = .loading
        interactor.disconnect()
            .subscribe(onCompleted: {
                self.state = .disconnected
                self.view?.updatePositionSliderUserInteractionEnabled(false)
                self.interactor.stopFireTVDiscovery()
                self.delegate?.didPressCloseButton(viewController)
            }, onError: { error in
                self.dependencies.logger.log(message: "interactor.disconnect(): \(error.localizedDescription)", event: .error)
                
                self.state = .disconnected
                self.view?.updatePositionSliderUserInteractionEnabled(false)
                self.interactor.stopFireTVDiscovery()
                self.delegate?.didPressCloseButton(viewController)
            }).disposed(by: disposeBag)
    }
    
    func didPressRewind10sButton() {
        guard state == .connected else {
            return
        }
        
        interactor.setPlayerPosition(-10 * 1000, type: RELATIVE)
            .subscribe(onCompleted: {
                self.dependencies.logger.log(message: "player rewind 10s", event: .info)
            }) { error in
                self.dependencies.logger.log(message: "interactor.setPlayerPosition() relative: \(error.localizedDescription)", event: .error)
            }.disposed(by: disposeBag)
    }
    
    func didPressPlayButton() {
        guard state == .connected else {
            return
        }
        
        interactor.play().subscribe(onCompleted: { [weak self] in
            self?.dependencies.logger.log(message: "player played", event: .info)
            self?.getDuration()
        }) { error in
            self.dependencies.logger.log(message: "interactor.play(): \(error.localizedDescription)", event: .error)
        }.disposed(by: disposeBag)
    }
    
    func didPressPauseButton() {
        guard state == .connected else {
            return
        }
        
        interactor.pause().subscribe(onCompleted: {
            self.dependencies.logger.log(message: "player paused", event: .info)
        }) { error in
            self.dependencies.logger.log(message: "interactor.pause(): \(error.localizedDescription)", event: .error)
        }.disposed(by: disposeBag)
    }
    
    func didPressStopButton() {
        guard state == .connected else {
            return
        }
        
        interactor.stop().subscribe(onCompleted: { [weak self] in
            self?.dependencies.logger.log(message: "player stopped", event: .info)
            self?.view?.setPosition(0)
            self?.view?.setPositionText("00:00:00")
            self?.view?.setMaximumPosition(0)
            self?.view?.setDurationText("00:00:00")
        }) { error in
            self.dependencies.logger.log(message: "interactor.stop(): \(error.localizedDescription)", event: .error)
        }.disposed(by: disposeBag)
    }
    
    func didPressFastForward10sButton() {
        guard state == .connected else {
            return
        }
        
        interactor.setPlayerPosition(10 * 1000, type: RELATIVE)
            .subscribe(onCompleted: {
                self.dependencies.logger.log(message: "player fast forward 10s", event: .info)
            }) { error in
                self.dependencies.logger.log(message: "interactor.setPlayerPosition() relative: \(error.localizedDescription)", event: .error)
            }.disposed(by: disposeBag)
    }
    
    func didChangePositionValue(_ position: Float) {
        guard state == .connected else {
            return
        }
        
        let positionString = dependencies.timeStringFactory.makeTimeString(fromPositionValue: position)
        view?.setPositionText(positionString)
    }
    
    func didChangePosition(_ position: Float) {
        guard state == .connected else {
            return
        }
        
        interactor.setPlayerPosition(position)
            .subscribe(onCompleted: {
                self.dependencies.logger.log(message: "player position changed", event: .info)
            }) { error in
                self.dependencies.logger.log(message: "interactor.setPlayerPosition() absolute: \(error.localizedDescription)", event: .error)
            }.disposed(by: disposeBag)
    }
}

extension FireTVPlayerPresenter {
    private func getDuration() {
        interactor.getDuration()
            .subscribe(onSuccess: { [weak self] duration in
                if let durationText = self?.dependencies.timeStringFactory.makeTimeString(fromMilliseconds: duration) {
                    self?.view?.setMaximumPosition(Float(duration))
                    self?.view?.setDurationText(durationText)
                    self?.view?.updatePositionSliderUserInteractionEnabled(true)
                }
            }) { error in
                self.dependencies.logger.log(message: "interactor.getDuration(): \(error.localizedDescription)", event: .error)
            }.disposed(by: disposeBag)
    }
    
    private func getPlayerInfo() {
        interactor.getPlayerInfo()
            .subscribe(onSuccess: { [weak self] playerInfo in
                do {
                    guard let metadataData = playerInfo.metadata().data(using: .utf8) else {
                        return
                    }
                    
                    let metadata = try JSONDecoder().decode(Metadata.self, from: metadataData)
                    
                    if let mediaName = metadata.title {
                        DispatchQueue.main.async { [weak self] in
                            self?.view?.setMediaName(mediaName)
                        }
                    }
                } catch {
                    self?.dependencies.logger.log(message: "getPlayerInfo(): \(error.localizedDescription)", event: .error)
                }
            }) { error in
                self.dependencies.logger.log(message: "interactor.getPlayerInfo(): \(error.localizedDescription)", event: .error)
            }.disposed(by: disposeBag)
    }
    
    private func getPlayerData() {
        interactor.getPlayerData()
            .subscribe(onSuccess: { [weak self] playerData in
                if let position = playerData.position, let positionString = self?.dependencies.timeStringFactory.makeTimeString(fromMilliseconds: position) {
                    DispatchQueue.main.async { [weak self] in
                        self?.view?.setPosition(Float(position))
                        self?.view?.setPositionText(positionString)
                    }
                }
                if let status = playerData.status {
                    DispatchQueue.main.async { [weak self] in
                        self?.view?.setStatus(status.stringValue)
                    }
                }
            }) { error in
                self.dependencies.logger.log(message: "interactor.getPlayerData(): \(error.localizedDescription)", event: .error)
            }.disposed(by: disposeBag)
    }
    
    private func observePlayerData() {
        interactor.playerData
            .subscribe(onNext: { [weak self] playerData in
                self?.dependencies.logger.log(message: "onNext getPlayerData()", event: .info)
                if let playerData = playerData {
                    if let position = playerData.position, let positionString = self?.dependencies.timeStringFactory.makeTimeString(fromMilliseconds: position) {
                        DispatchQueue.main.async { [weak self] in
                            self?.view?.setPosition(Float(position))
                            self?.view?.setPositionText(positionString)
                        }
                    }
                    if let status = playerData.status {
                        DispatchQueue.main.async { [weak self] in
                            if status.rawValue == ReadyToPlay.rawValue {
                                self?.getDuration()
                            }
                            
                            self?.view?.setStatus(status.stringValue)
                        }
                    }
                }
            }, onError: { error in
                self.dependencies.logger.log(message: "interactor.playerData: \(error.localizedDescription)", event: .error)
            }).disposed(by: disposeBag)
    }
    
    private func updateUI(forState state: FireTVPlayerPresenterState) {
        switch state {
            case .connected:
				let viewModel = FireTVPlayerViewViewModel(isCloseButtonHidden: false, isPlayerControlEnabled: true, isActivityIndicatorViewHidden: true, isPositionStackViewHidden: false, isControlStackViewHidden: false, hideLabels: false)
                view?.updateUI(withViewModel: viewModel)
            
            case .disconnected:
				let viewModel = FireTVPlayerViewViewModel(isCloseButtonHidden: false, isPlayerControlEnabled: false, isActivityIndicatorViewHidden: true, isPositionStackViewHidden: false, isControlStackViewHidden: false, hideLabels: false)
                view?.updateUI(withViewModel: viewModel)
                view?.setStatus(String(describing: state))
            
            case .loading:
				let viewModel = FireTVPlayerViewViewModel(isCloseButtonHidden: true, isPlayerControlEnabled: false, isActivityIndicatorViewHidden: false, isPositionStackViewHidden: true, isControlStackViewHidden: true, hideLabels: true)
                view?.updateUI(withViewModel: viewModel)
            
            case .error:
				let viewModel = FireTVPlayerViewViewModel(isCloseButtonHidden: false, isPlayerControlEnabled: false, isActivityIndicatorViewHidden: true, isPositionStackViewHidden: true, isControlStackViewHidden: true, hideLabels: false)
                view?.updateUI(withViewModel: viewModel)
        }
    }
}
