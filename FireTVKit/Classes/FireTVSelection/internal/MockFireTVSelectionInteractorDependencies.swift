//
//  MockFireTVSelectionInteractorDependencies.swift
//  FireTVKit
//
//  Created by crelies on 17.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

struct MockFireTVSelectionInteractorDependencies: FireTVSelectionInteractorDependenciesProtocol {
    let playerDiscoveryController: PlayerDiscoveryControllerProtocol
    let playerDiscoveryService: PlayerDiscoveryServiceProtocol
    let playerService: PlayerServiceProtocol
    
    init() {
        playerDiscoveryController = MockServiceFactory.makePlayerDiscoveryController()
        playerDiscoveryService = MockServiceFactory.makePlayerDiscoveryService()
        playerService = MockServiceFactory.makePlayerService()
    }
}
