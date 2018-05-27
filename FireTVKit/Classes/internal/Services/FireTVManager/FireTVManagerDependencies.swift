//
//  FireTVManagerDependencies.swift
//  FireTVKit
//
//  Created by crelies on 30.03.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

protocol FireTVManagerDependenciesProtocol: PlayerDiscoveryControllerProvider, PlayerDiscoveryServiceProvider {
    
}

struct FireTVManagerDependencies: FireTVManagerDependenciesProtocol {
	let playerDiscoveryController: PlayerDiscoveryControllerProtocol
    let playerDiscoveryService: PlayerDiscoveryServiceProtocol
    
    init() {
		playerDiscoveryController = ServiceFactory.makePlayerDiscoveryController()
        playerDiscoveryService = ServiceFactory.makePlayerDiscoveryService()
    }
}
