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
    func setPresenter(_ presenter: FireTVSelectionPresenterProtocol)
	func startFireTVDiscovery() throws
	func getFireTVs() -> Observable<[RemoteMediaPlayer]?>
	func stopFireTVDiscovery()
}

final class FireTVSelectionInteractor: FireTVSelectionInteractorInputProtocol {
    private weak var presenter: FireTVSelectionPresenterProtocol?
    private var dependencies: FireTVSelectionInteractorDependenciesProtocol
    private let playerId: String
    
    init(dependencies: FireTVSelectionInteractorDependenciesProtocol, playerId: String) {
        self.dependencies = dependencies
        self.playerId = playerId
		
		var playerDiscoveryService = self.dependencies.playerDiscoveryService
        playerDiscoveryService.playerServiceID = playerId
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
        try PlayerDiscoveryController.shared.startSearch(forPlayerId: playerId)
	}
	
	func getFireTVs() -> Observable<[RemoteMediaPlayer]?> {
		return dependencies.playerDiscoveryService.devicesVariable.asObservable()
	}
	
	func stopFireTVDiscovery() {
        dependencies.playerDiscoveryService.stopDiscovering()
        PlayerDiscoveryController.shared.stopSearch()
	}
}
