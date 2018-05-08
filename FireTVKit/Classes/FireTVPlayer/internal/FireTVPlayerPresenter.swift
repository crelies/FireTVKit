//
//  FireTVPlayerPresenter.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import RxSwift
import UIKit

protocol FireTVPlayerPresenterProtocol: class, FireTVPlayerInteractorOutputProtocol {
    func viewDidLoad()
    func didPressCloseButton()
    func didPressPlayButton()
    func didPressPauseButton()
    func didPressStopButton()
}

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
    
    init(dependencies: FireTVPlayerPresenterDependenciesProtocol, view: FireTVPlayerViewProtocol, interactor: FireTVPlayerInteractorInputProtocol, router: FireTVPlayerRouterProtocol) {
        self.dependencies = dependencies
        self.view = view
        self.interactor = interactor
        self.router = router
        self.disposeBag = DisposeBag()
        self.state = .disconnected
    }
    
    // TODO: remove me
    deinit {
        print("FireTVPlayerPresenter deinit")
    }
    
    func viewDidLoad() {
        do {
            try PlayerDiscoveryController.shared.startSearch(forPlayerId: nil)
        } catch {
            // TODO:
        }
        
        view?.setPlayerName(interactor.getPlayerName())
        view?.setPositionText("00:00:00")
        view?.setDurationText("00:00:00")
        state = .disconnected
        
        interactor.connect()
            .subscribe(onCompleted: { [weak self] in
                self?.state = .connected
                self?.getDuration()
                self?.observePlayerData()
            }) { error in
                // TODO:
                print("interactor.connect(): \(error.localizedDescription)")
            }.disposed(by: disposeBag)
    }
    
    func didPressCloseButton() {
        guard let viewController = view as? UIViewController else {
            return
        }
        
        interactor.disconnect()
            .subscribe(onCompleted: {
                self.state = .disconnected
                PlayerDiscoveryController.shared.stopSearch()
                self.router.dismiss(viewController: viewController)
            }, onError: { error in
                // TODO:
                print("interactor.disconnect(): \(error.localizedDescription)")
                
                if let playerServiceError = error as? PlayerServiceError, playerServiceError == PlayerServiceError.currentPlayerComparisonFailed {
                    self.state = .disconnected
                    PlayerDiscoveryController.shared.stopSearch()
                    self.router.dismiss(viewController: viewController)
                }
            }).disposed(by: disposeBag)
    }
    
    func didPressPlayButton() {
        interactor.play().subscribe(onCompleted: { [weak self] in
            print("player played")
            self?.getDuration()
        }) { error in
            // TODO:
            print("interactor.play(): \(error.localizedDescription)")
        }.disposed(by: disposeBag)
    }
    
    func didPressPauseButton() {
        interactor.pause().subscribe(onCompleted: {
            print("player paused")
        }) { error in
            // TODO:
            print("interactor.pause(): \(error.localizedDescription)")
        }.disposed(by: disposeBag)
    }
    
    func didPressStopButton() {
        interactor.stop().subscribe(onCompleted: {
            print("player stopped")
        }) { error in
            // TODO:
            print("interactor.stop(): \(error.localizedDescription)")
        }.disposed(by: disposeBag)
    }
}

extension FireTVPlayerPresenter {
    private func createDurationText(fromDuration duration: Int) -> String {
        let durationInSeconds = Int(duration / 1000)
        let hours = Int(durationInSeconds / 60 / 60)
        let minutes = Int(durationInSeconds / 60) - (hours * 60)
        let seconds = Int(durationInSeconds) - (minutes * 60)
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func getDuration() {
        interactor.getDuration()
            .subscribe(onSuccess: { [weak self] duration in
                if let durationText = self?.createDurationText(fromDuration: duration) {
                    self?.view?.setDurationText(durationText)
                }
            }) { error in
                // TODO:
                print("interactor.getDuration(): \(error.localizedDescription)")
            }.disposed(by: disposeBag)
    }
    
    private func observePlayerData() {
        interactor.getPlayerData()
            .subscribe(onNext: { [weak self] playerData in
                print("onNext getPlayerData()")
                if let playerData = playerData {
                    if let positionString = playerData.positionString {
                        DispatchQueue.main.async { [weak self] in
                            self?.view?.setPositionText(positionString)
                        }
                    }
                }
            }, onError: { error in
                // TODO:
                print("interactor.getPlayerData(): \(error.localizedDescription)")
            }).disposed(by: disposeBag)
    }
    
    private func updateUI(forState state: FireTVPlayerPresenterState) {
        switch state {
            case .connected:
                let viewModel = FireTVPlayerViewControllerViewModel(isPlayerControlEnabled: true)
                view?.updateUI(withViewModel: viewModel)
            
            case .disconnected:
                let viewModel = FireTVPlayerViewControllerViewModel(isPlayerControlEnabled: false)
                view?.updateUI(withViewModel: viewModel)
        }
    }
}
