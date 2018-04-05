//
//  FireTVSelectionInteractorDependencies.swift
//  FireTVKit
//
//  Created by crelies on 05.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

protocol FireTVSelectionInteractorDependenciesProtocol: HasPlayerDiscoveryService {
    
}

struct FireTVSelectionInteractorDependencies: FireTVSelectionInteractorDependenciesProtocol {
    var playerDiscoveryService: PlayerDiscoveryServiceProtocol
	
	init() {
		playerDiscoveryService = ServiceFactory.makePlayerDiscoveryService()
	}
}
