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
    var playerData: Observable<PlayerData?> { get }
    
    func setPresenter(_ presenter: FireTVPlayerPresenterProtocol)
	func startFireTVDiscovery()
	func stopFireTVDiscovery()
    func connect() -> Completable
    func getPlayerName() -> String
    func getPlayerData() -> Single<PlayerData>
    func getDuration() -> Single<Int64>
    func play() -> Completable
    func pause() -> Completable
    func stop() -> Completable
    func setPlayerPosition(_ playerPosition: Float) -> Completable
    func setPlayerPosition(_ playerPosition: Float, type: SeekType) -> Completable
    func disconnect() -> Completable
}

extension FireTVPlayerInteractorInputProtocol {
    func setPlayerPosition(_ playerPosition: Float) -> Completable {
        return setPlayerPosition(playerPosition, type: ABSOLUTE)
    }
}

final class FireTVPlayerInteractor: FireTVPlayerInteractorInputProtocol {
    private weak var presenter: FireTVPlayerPresenterProtocol?
    private let dependencies: FireTVPlayerInteractorDependenciesProtocol
    private let player: RemoteMediaPlayer
    
    var playerData: Observable<PlayerData?> {
        return dependencies.playerService.playerData
    }
    
    init(dependencies: FireTVPlayerInteractorDependenciesProtocol, player: RemoteMediaPlayer) {
        self.dependencies = dependencies
        self.player = player
    }
    
    func setPresenter(_ presenter: FireTVPlayerPresenterProtocol) {
        self.presenter = presenter
    }
	
	func startFireTVDiscovery() {
		dependencies.playerDiscoveryController.startSearch(forPlayerId: nil)
	}
	
	func stopFireTVDiscovery() {
		dependencies.playerDiscoveryController.stopSearch()
	}
    
    func connect() -> Completable {
        return dependencies.playerService.connectToPlayer(player)
    }
    
    func getPlayerName() -> String {
        return player.name()
    }
    
    func getPlayerData() -> Single<PlayerData> {
        return dependencies.playerService.getPlayerData()
    }
    
    func getDuration() -> Single<Int64> {
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
    
    func setPlayerPosition(_ playerPosition: Float, type: SeekType) -> Completable {
        return dependencies.playerService.setPosition(position: Int64(playerPosition), type: type)
    }
    
    func disconnect() -> Completable {
        return dependencies.playerService.disconnect(fromPlayer: player)
    }
}
