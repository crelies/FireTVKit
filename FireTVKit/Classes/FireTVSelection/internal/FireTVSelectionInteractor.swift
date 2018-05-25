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
    var fireTVs: Observable<[RemoteMediaPlayer]?> { get }
    
    func setPresenter(_ presenter: FireTVSelectionPresenterProtocol)
	func startFireTVDiscovery() throws
    func playMedia(onPlayer player: RemoteMediaPlayer)
	func stopFireTVDiscovery()
}

final class FireTVSelectionInteractor: FireTVSelectionInteractorInputProtocol {
    private weak var presenter: FireTVSelectionPresenterProtocol?
    private var dependencies: FireTVSelectionInteractorDependenciesProtocol
    private let playerId: String
    private var media: FireTVMedia?
    private let disposeBag: DisposeBag
    
    var fireTVs: Observable<[RemoteMediaPlayer]?> {
        return dependencies.playerDiscoveryService.devicesVariable.asObservable().skip(1)
    }
    
    init(dependencies: FireTVSelectionInteractorDependenciesProtocol, playerId: String, media: FireTVMedia?) {
        self.dependencies = dependencies
        self.playerId = playerId
        self.media = media
        self.disposeBag = DisposeBag()
    }
	
	// TODO: remove me
	deinit {
		print("FireTVSelectionInteractor deinit")
	}
    
    func setPresenter(_ presenter: FireTVSelectionPresenterProtocol) {
        self.presenter = presenter
    }
	
	func startFireTVDiscovery() throws {
		try dependencies.playerDiscoveryService.startDiscovering()
        dependencies.playerDiscoveryController.startSearch(forPlayerId: playerId)
	}
    
    func playMedia(onPlayer player: RemoteMediaPlayer) {
        guard let media = media else {
            return
        }
        
        var playerService = dependencies.playerService
        playerService.player = player
        
        playerService.play(withMetadata: media.metadata, url: media.url.absoluteString)
            .subscribe(onCompleted: {
                print("media played")
            }) { error in
                print("interactor.playMedia(): \(error.localizedDescription)")
            }.disposed(by: disposeBag)
    }
	
	func stopFireTVDiscovery() {
        dependencies.playerDiscoveryService.stopDiscovering()
        dependencies.playerDiscoveryController.stopSearch()
	}
}
