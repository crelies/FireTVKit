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
    func playMedia(onPlayer player: RemoteMediaPlayer)
	func stopFireTVDiscovery()
}

final class FireTVSelectionInteractor: FireTVSelectionInteractorInputProtocol {
    private weak var presenter: FireTVSelectionPresenterProtocol?
    private var dependencies: FireTVSelectionInteractorDependenciesProtocol
    private let playerId: String
    private var media: FireTVMedia?
    private let disposeBag: DisposeBag
    
    var fireTVs: Observable<[RemoteMediaPlayer]> {
        return dependencies.playerDiscoveryService.devicesVariable
            .asObservable()
            .flatMap { Observable.from(optional: $0) }
    }
    
    var discoveryFailure: Observable<DiscoveringInfo> {
        return dependencies.playerDiscoveryService.discoveringInfo
            .asObservable()
            .flatMap { Observable.from(optional: $0) }
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
    
    func playMedia(onPlayer player: RemoteMediaPlayer) {
        guard let media = media else {
            return
        }
        
        var playerService = dependencies.playerService
        playerService.player = player
        
        playerService.play(withMetadata: media.metadata, url: media.url.absoluteString)
            .subscribe(onCompleted: {
                self.dependencies.logger.log(message: "media played", event: .info)
            }) { error in
                self.dependencies.logger.log(message: "interactor.playMedia(): \(error.localizedDescription)", event: .error)
            }.disposed(by: disposeBag)
    }
	
	func stopFireTVDiscovery() {
        dependencies.playerDiscoveryService.stopDiscovering()
        dependencies.playerDiscoveryController.stopSearch()
	}
}
