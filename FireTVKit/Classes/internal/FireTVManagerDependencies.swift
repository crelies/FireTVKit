//
//  FireTVManagerDependencies.swift
//  FireTVKit
//
//  Created by crelies on 30.03.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

internal protocol FireTVManagerDependenciesProtocol: HasPlayerDiscoveryService {
    
}

internal struct FireTVManagerDependencies: FireTVManagerDependenciesProtocol {
    var playerDiscoveryService: PlayerDiscoveryServiceProtocol
    
    init() {
        playerDiscoveryService = ServiceFactory.makePlayerDiscoveryService()
    }
}
