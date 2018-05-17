//
//  MockPlayerDiscoveryServiceDependencies.swift
//  FireTVKit
//
//  Created by crelies on 17.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

struct MockPlayerDiscoveryServiceDependencies: PlayerDiscoveryServiceDependenciesProtocol {
	let playerDiscoveryController: PlayerDiscoveryControllerProtocol
	
	init() {
		playerDiscoveryController = MockServiceFactory.makePlayerDiscoveryController()
	}
}
