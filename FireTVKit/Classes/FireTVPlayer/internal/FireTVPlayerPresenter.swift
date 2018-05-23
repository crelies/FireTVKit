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
    
    // TODO: remove me
    deinit {
        print("FireTVPlayerPresenter deinit")
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
                // TODO:
                print("interactor.connect(): \(error.localizedDescription)")
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
                // TODO:
                print("interactor.disconnect(): \(error.localizedDescription)")
                
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
                print("player rewind 10s")
            }) { error in
                // TODO:
                print("interactor.setPlayerPosition() relative: \(error.localizedDescription)")
            }.disposed(by: disposeBag)
    }
    
    func didPressPlayButton() {
        guard state == .connected else {
            return
        }
        
        interactor.play().subscribe(onCompleted: { [weak self] in
            print("player played")
            self?.getDuration()
        }) { error in
            // TODO:
            print("interactor.play(): \(error.localizedDescription)")
        }.disposed(by: disposeBag)
    }
    
    func didPressPauseButton() {
        guard state == .connected else {
            return
        }
        
        interactor.pause().subscribe(onCompleted: {
            print("player paused")
        }) { error in
            // TODO:
            print("interactor.pause(): \(error.localizedDescription)")
        }.disposed(by: disposeBag)
    }
    
    func didPressStopButton() {
        guard state == .connected else {
            return
        }
        
        interactor.stop().subscribe(onCompleted: { [weak self] in
            print("player stopped")
            self?.view?.setPosition(0)
            self?.view?.setPositionText("00:00:00")
            self?.view?.setMaximumPosition(0)
            self?.view?.setDurationText("00:00:00")
        }) { error in
            // TODO:
            print("interactor.stop(): \(error.localizedDescription)")
        }.disposed(by: disposeBag)
    }
    
    func didPressFastForward10sButton() {
        guard state == .connected else {
            return
        }
        
        interactor.setPlayerPosition(10 * 1000, type: RELATIVE)
            .subscribe(onCompleted: {
                print("player fast forward 10s")
            }) { error in
                // TODO:
                print("interactor.setPlayerPosition() relative: \(error.localizedDescription)")
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
                print("player position changed")
            }) { error in
                // TODO:
                print("interactor.setPlayerPosition() absolute: \(error.localizedDescription)")
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
                // TODO:
                print("interactor.getDuration(): \(error.localizedDescription)")
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
                    print("getPlayerInfo(): \(error.localizedDescription)")
                }
            }) { error in
                // TODO:
                print("interactor.getPlayerInfo(): \(error.localizedDescription)")
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
                // TODO:
                print("interactor.getPlayerData(): \(error.localizedDescription)")
            }.disposed(by: disposeBag)
    }
    
    private func observePlayerData() {
        interactor.playerData
            .subscribe(onNext: { [weak self] playerData in
                print("onNext getPlayerData()")
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
                // TODO:
                print("interactor.playerData: \(error.localizedDescription)")
            }).disposed(by: disposeBag)
    }
    
    private func updateUI(forState state: FireTVPlayerPresenterState) {
        switch state {
            case .connected:
                let viewModel = FireTVPlayerViewViewModel(isPlayerControlEnabled: true, isActivityIndicatorViewHidden: true, isPositionStackViewHidden: false, isControlStackViewHidden: false)
                view?.updateUI(withViewModel: viewModel)
            
            case .disconnected:
                let viewModel = FireTVPlayerViewViewModel(isPlayerControlEnabled: false, isActivityIndicatorViewHidden: true, isPositionStackViewHidden: false, isControlStackViewHidden: false)
                view?.updateUI(withViewModel: viewModel)
            
            case .loading:
                let viewModel = FireTVPlayerViewViewModel(isPlayerControlEnabled: false, isActivityIndicatorViewHidden: false, isPositionStackViewHidden: true, isControlStackViewHidden: true)
                view?.updateUI(withViewModel: viewModel)
            
            case .error:
                let viewModel = FireTVPlayerViewViewModel(isPlayerControlEnabled: false, isActivityIndicatorViewHidden: true, isPositionStackViewHidden: true, isControlStackViewHidden: true)
                view?.updateUI(withViewModel: viewModel)
        }
    }
}
