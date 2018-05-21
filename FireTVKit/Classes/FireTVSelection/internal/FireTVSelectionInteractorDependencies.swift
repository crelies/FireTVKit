//
//  FireTVSelectionInteractorDependencies.swift
//  FireTVKit
//
//  Created by crelies on 05.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

protocol FireTVSelectionInteractorDependenciesProtocol: PlayerDiscoveryControllerProvider, HasPlayerDiscoveryService, PlayerServiceProvider {
    
}

struct FireTVSelectionInteractorDependencies: FireTVSelectionInteractorDependenciesProtocol {
	let playerDiscoveryController: PlayerDiscoveryControllerProtocol
	let playerDiscoveryService: PlayerDiscoveryServiceProtocol
    let playerService: PlayerServiceProtocol
	
	init() {
		playerDiscoveryController = ServiceFactory.makePlayerDiscoveryController()
		playerDiscoveryService = ServiceFactory.makePlayerDiscoveryService()
        playerService = ServiceFactory.makePlayerService()
	}
}
