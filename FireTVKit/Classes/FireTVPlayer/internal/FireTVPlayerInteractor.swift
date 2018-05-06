//
//  FireTVPlayerInteractor.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation
import RxSwift

protocol FireTVPlayerInteractorOutputProtocol {
    
}

protocol FireTVPlayerInteractorInputProtocol {
    func setPresenter(_ presenter: FireTVPlayerPresenterProtocol)
    func connect() -> Completable
    func getPlayerName() -> String
    func getPlayerData() -> Observable<PlayerData?>
    func getDuration() -> Single<Int>
    func play() -> Completable
    func pause() -> Completable
    func stop() -> Completable
    func disconnect() -> Completable
}

final class FireTVPlayerInteractor: FireTVPlayerInteractorInputProtocol {
    private weak var presenter: FireTVPlayerPresenterProtocol?
    private let dependencies: FireTVPlayerInteractorDependenciesProtocol
    private let player: RemoteMediaPlayer
    
    init(dependencies: FireTVPlayerInteractorDependenciesProtocol, player: RemoteMediaPlayer) {
        self.dependencies = dependencies
        self.player = player
    }
    
    func setPresenter(_ presenter: FireTVPlayerPresenterProtocol) {
        self.presenter = presenter
    }
    
    func connect() -> Completable {
        return dependencies.playerService.connectToPlayer(player)
    }
    
    func getPlayerName() -> String {
        return player.name()
    }
    
    func getPlayerData() -> Observable<PlayerData?> {
        return dependencies.playerService.playerData
    }
    
    func getDuration() -> Single<Int> {
        return dependencies.playerService.getDuration()
    }
    
    func play() -> Completable {
        return dependencies.playerService.play()
    }
    
    func pause() -> Completable {
        return dependencies.playerService.pause()
    }
    
    func stop() -> Completable {
        return dependencies.playerService.stop()
    }
    
    func disconnect() -> Completable {
        return dependencies.playerService.disconnect(fromPlayer: player)
    }
}
