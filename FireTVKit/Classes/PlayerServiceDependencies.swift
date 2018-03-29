//
//  PlayerServiceDependencies.swift
//  FireTVKit
//
//  Created by crelies on 28.11.2017.
//  Copyright © 2017 Christian Elies. All rights reserved.
//

import Foundation

internal protocol PlayerServiceDependenciesProtocol: HasPlayerDiscoveryService {
	
}

internal struct PlayerServiceDependencies: PlayerServiceDependenciesProtocol {
	var playerDiscoveryService: PlayerDiscoveryServiceProtocol
	
	init() {
		playerDiscoveryService = ServiceFactory.makePlayerDiscoveryService()
	}
}
