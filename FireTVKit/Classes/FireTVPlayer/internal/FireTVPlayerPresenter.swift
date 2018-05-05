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
    
    init(dependencies: FireTVPlayerPresenterDependenciesProtocol, view: FireTVPlayerViewProtocol, interactor: FireTVPlayerInteractorInputProtocol, router: FireTVPlayerRouterProtocol) {
        self.dependencies = dependencies
        self.view = view
        self.interactor = interactor
        self.router = router
        self.disposeBag = DisposeBag()
    }
    
    // TODO: remove me
    deinit {
        print("FireTVPlayerPresenter deinit")
    }
    
    func viewDidLoad() {
        view?.setPlayerName(interactor.getPlayerName())
        view?.setPositionText("00:00:00")
        view?.setDurationText("00:00:00")
        
        interactor.connect()
            .subscribe(onCompleted: { [weak self] in
                self?.getDuration()
                self?.observePlayerData()
            }) { error in
                // TODO:
                print(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
    func didPressCloseButton() {
        guard let viewController = view as? UIViewController else {
            return
        }
        
        if let disconnect = interactor.disconnect() {
            disconnect
                .subscribe(onCompleted: {
                    self.router.dismiss(viewController: viewController)
                }, onError: { error in
                    // TODO:
                    print(error.localizedDescription)
                }).disposed(by: disposeBag)
        } else {
            router.dismiss(viewController: viewController)
        }
    }
    
    func didPressPlayButton() {
        interactor.play().subscribe(onCompleted: {
            print("player played")
        }) { error in
            // TODO:
            print(error.localizedDescription)
        }.disposed(by: disposeBag)
    }
    
    func didPressPauseButton() {
        interactor.pause().subscribe(onCompleted: {
            print("player paused")
        }) { error in
            // TODO:
            print(error.localizedDescription)
        }.disposed(by: disposeBag)
    }
    
    func didPressStopButton() {
        interactor.stop().subscribe(onCompleted: {
            print("player stopped")
        }) { error in
            // TODO:
            print(error.localizedDescription)
        }.disposed(by: disposeBag)
    }
}

extension FireTVPlayerPresenter {
    private func createDurationText(fromDuration duration: Int) -> String {
        let hours = Int(duration / (60 * 60))
        let minutes = Int((duration / 60) % 60)
        let seconds = Int(duration % 60)
        
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
                print(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
    private func observePlayerData() {
        interactor.getPlayerData()
            .subscribe(onNext: { [weak self] playerData in
                if let playerData = playerData {
                    if let positionString = playerData.positionString {
                        self?.view?.setPositionText(positionString)
                    }
                }
            }, onError: { error in
                // TODO:
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}
