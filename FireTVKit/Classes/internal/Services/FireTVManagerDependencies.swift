//
//  FireTVManagerDependencies.swift
//  FireTVKit
//
//  Created by crelies on 30.03.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

protocol FireTVManagerDependenciesProtocol: HasPlayerDiscoveryService {
    
}

struct FireTVManagerDependencies: FireTVManagerDependenciesProtocol {
    let playerDiscoveryService: PlayerDiscoveryServiceProtocol
    
    init() {
        playerDiscoveryService = ServiceFactory.makePlayerDiscoveryService()
    }
}
