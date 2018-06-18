//
//  FireTVSelectionInteractor.swift
//  FireTVKit
//
//  Created by crelies on 05.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation
import RxSwift

protocol FireTVSelectionInteractorOutputProtocol {

}

protocol FireTVSelectionInteractorInputProtocol {
    var fireTVs: Observable<[RemoteMediaPlayer]> { get }
    var discoveryFailure: Observable<DiscoveringInfo> { get }
    
    func setPresenter(_ presenter: FireTVSelectionPresenterProtocol)
	func startFireTVDiscovery()
    func playMedia(onPlayer player: RemoteMediaPlayer) -> Completable?
	func stopFireTVDiscovery()
}

final class FireTVSelectionInteractor: FireTVSelectionInteractorInputProtocol {
    private weak var presenter: FireTVSelectionPresenterProtocol?
    private var dependencies: FireTVSelectionInteractorDependenciesProtocol
    private let playerId: String
    private var media: FireTVMedia?
    private let disposeBag: DisposeBag
    
    var fireTVs: Observable<[RemoteMediaPlayer]> {
        return dependencies.playerDiscoveryService.devicesObservable
    }
    
    var discoveryFailure: Observable<DiscoveringInfo> {
        return dependencies.playerDiscoveryService.discoveringInfoObservable
            .filter { $0.status == .discoveryFailure }
    }
    
    init(dependencies: FireTVSelectionInteractorDependenciesProtocol, playerId: String, media: FireTVMedia?) {
        self.dependencies = dependencies
        self.playerId = playerId
        self.media = media
        self.disposeBag = DisposeBag()
    }
	
	deinit {
        dependencies.logger.log(message: "FireTVSelectionInteractor deinit", event: .info)
	}
    
    func setPresenter(_ presenter: FireTVSelectionPresenterProtocol) {
        self.presenter = presenter
    }
	
	func startFireTVDiscovery() {
		dependencies.playerDiscoveryService.startDiscovering()
        dependencies.playerDiscoveryController.startSearch(forPlayerId: playerId)
	}
    
    func playMedia(onPlayer player: RemoteMediaPlayer) -> Completable? {
        guard let media = media else {
            return nil
        }
        
        var playerService = dependencies.playerService
        playerService.player = player
        
        return playerService.play(withMetadata: media.metadata, url: media.url.absoluteString)
    }
	
	func stopFireTVDiscovery() {
        dependencies.playerDiscoveryService.stopDiscovering()
        dependencies.playerDiscoveryController.stopSearch()
	}
}
