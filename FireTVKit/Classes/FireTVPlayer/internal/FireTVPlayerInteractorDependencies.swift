//
//  FireTVPlayerInteractorDependencies.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

protocol FireTVPlayerInteractorDependenciesProtocol: PlayerDiscoveryControllerProvider, PlayerServiceProvider {
    
}

struct FireTVPlayerInteractorDependencies: FireTVPlayerInteractorDependenciesProtocol {
	let playerDiscoveryController: PlayerDiscoveryControllerProtocol
	let playerService: PlayerServiceProtocol
    
    init() {
		playerDiscoveryController = ServiceFactory.makePlayerDiscoveryController()
        playerService = ServiceFactory.makePlayerService()
    }
}
