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
    private var state: FireTVPlayerPresenterState
	private let theme: FireTVPlayerThemeProtocol
    private weak var delegate: FireTVPlayerDelegateProtocol?
    private let noWifiAlertTitle: String
    private let noWifiAlertMessage: String
    
    init(dependencies: FireTVPlayerPresenterDependenciesProtocol, view: FireTVPlayerViewProtocol, interactor: FireTVPlayerInteractorInputProtocol, router: FireTVPlayerRouterProtocol, theme: FireTVPlayerThemeProtocol, delegate: FireTVPlayerDelegateProtocol?, noWifiAlertTitle: String, noWifiAlertMessage: String) {
        self.dependencies = dependencies
        self.view = view
        self.interactor = interactor
        self.router = router
		self.theme = theme
        self.delegate = delegate
        self.noWifiAlertTitle = noWifiAlertTitle
        self.noWifiAlertMessage = noWifiAlertMessage
        
        self.disposeBag = DisposeBag()
        self.state = .disconnected
    }
    
    deinit {
        dependencies.logger.log(message: "FireTVPlayerPresenter deinit", event: .info)
    }
    
    func viewDidLoad() {
        updateUI(forState: .disconnected, animated: false)
        
        if dependencies.reachabilityService.reachability.connection == .wifi {
            interactor.startFireTVDiscovery()
        }
		
		view?.setTheme(theme)
        view?.setPlayerName(interactor.getPlayerName())
        view?.setPosition(0)
        view?.setPositionText("00:00:00")
        view?.setMaximumPosition(0)
        view?.setDurationText("00:00:00")
        
        if dependencies.reachabilityService.reachability.connection == .wifi {
            updateUI(forState: .loading, animated: false)
            interactor.connect()
                .subscribe(onCompleted: { [weak self] in
					self?.updateUI(forState: .connected, animated: true)
                    self?.getDuration()
                    self?.getPlayerMetadata()
                    self?.getPlayerData()
                    self?.observePlayerData()
                }) { [weak self] error in
                    self?.dependencies.logger.log(message: "interactor.connect(): \(error.localizedDescription)", event: .error)
                    self?.updateUI(forState: .disconnected, animated: true)
                }.disposed(by: disposeBag)
        }
    }
    
    func viewWillAppear() {
        if dependencies.reachabilityService.reachability.connection != .wifi, let viewController = view as? FireTVPlayerViewController {
            router.showNoWifiAlert(fromViewController: viewController, title: noWifiAlertTitle, message: noWifiAlertMessage, buttonColor: theme.closeButtonTintColor) { [weak self] in
				self?.updateUI(forState: .loading, animated: true)
                self?.delegate?.didPressCloseButton(viewController)
            }
        }
    }
    
    func didPressCloseButton() {
        guard let viewController = view as? FireTVPlayerViewController else {
            return
        }
        
        updateUI(forState: .loading, animated: true)
        interactor.disconnect()
            .subscribe(onCompleted: {
                self.updateUI(forState: .disconnected, animated: true)
                self.view?.updatePositionSliderUserInteractionEnabled(false)
                self.interactor.stopFireTVDiscovery()
                self.delegate?.didPressCloseButton(viewController)
            }, onError: { error in
                self.dependencies.logger.log(message: "interactor.disconnect(): \(error.localizedDescription)", event: .error)
                
                self.updateUI(forState: .disconnected, animated: true)
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
        
        let positionString = dependencies.timeStringFactory.makeTimeString(fromMilliseconds: position)
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
                if let durationText = self?.dependencies.timeStringFactory.makeTimeString(fromMilliseconds: Float(duration)) {
                    self?.view?.setMaximumPosition(Float(duration))
                    self?.view?.setDurationText(durationText)
                    self?.view?.updatePositionSliderUserInteractionEnabled(true)
                }
            }) { error in
                self.dependencies.logger.log(message: "interactor.getDuration(): \(error.localizedDescription)", event: .error)
            }.disposed(by: disposeBag)
    }
    
    private func getPlayerMetadata() {
        interactor.getPlayerMetadata()
            .subscribe(onSuccess: { [weak self] metadata in
                if let mediaName = metadata.title {
                    DispatchQueue.main.async { [weak self] in
                        self?.view?.setMediaName(mediaName)
                    }
                }
            }) { error in
                self.dependencies.logger.log(message: "interactor.getPlayerMetadata(): \(error.localizedDescription)", event: .error)
            }.disposed(by: disposeBag)
    }
    
    private func getPlayerData() {
        interactor.getPlayerData()
            .subscribe(onSuccess: { [weak self] playerData in
                if let position = playerData.position, let positionString = self?.dependencies.timeStringFactory.makeTimeString(fromMilliseconds: Float(position)) {
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
                    if let position = playerData.position, let positionString = self?.dependencies.timeStringFactory.makeTimeString(fromMilliseconds: Float(position)) {
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
    
	private func updateUI(forState state: FireTVPlayerPresenterState, animated: Bool) {
		self.state = state
        switch state {
            case .connected:
				let viewModel = FireTVPlayerViewViewModel(isCloseButtonHidden: false, isPlayerControlEnabled: true, isActivityIndicatorViewHidden: true, isPositionStackViewHidden: false, isControlStackViewHidden: false, hideLabels: false)
				view?.updateUI(withViewModel: viewModel, animated: animated)
            
            case .disconnected:
				let viewModel = FireTVPlayerViewViewModel(isCloseButtonHidden: false, isPlayerControlEnabled: false, isActivityIndicatorViewHidden: true, isPositionStackViewHidden: false, isControlStackViewHidden: false, hideLabels: false)
                view?.updateUI(withViewModel: viewModel, animated: animated)
                view?.setStatus(String(describing: state))
            
            case .loading:
				let viewModel = FireTVPlayerViewViewModel(isCloseButtonHidden: true, isPlayerControlEnabled: false, isActivityIndicatorViewHidden: false, isPositionStackViewHidden: true, isControlStackViewHidden: true, hideLabels: true)
				view?.updateUI(withViewModel: viewModel, animated: animated)
            
            case .error:
				let viewModel = FireTVPlayerViewViewModel(isCloseButtonHidden: false, isPlayerControlEnabled: false, isActivityIndicatorViewHidden: true, isPositionStackViewHidden: true, isControlStackViewHidden: true, hideLabels: false)
                view?.updateUI(withViewModel: viewModel, animated: animated)
        }
    }
}
