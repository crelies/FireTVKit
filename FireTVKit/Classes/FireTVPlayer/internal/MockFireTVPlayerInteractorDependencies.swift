//
//  MockFireTVPlayerInteractorDependencies.swift
//  FireTVKit
//
//  Created by crelies on 17.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

struct MockFireTVPlayerInteractorDependencies: FireTVPlayerInteractorDependenciesProtocol {
	let playerDiscoveryController: PlayerDiscoveryControllerProtocol
	let playerService: PlayerServiceProtocol
	
	init() {
		playerDiscoveryController = MockServiceFactory.makePlayerDiscoveryController()
		playerService = MockServiceFactory.makePlayerService()
	}
}
