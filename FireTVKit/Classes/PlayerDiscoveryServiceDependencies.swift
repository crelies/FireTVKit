//
//  PlayerDiscoveryServiceDependencies.swift
//  FireTVKit
//
//  Created by crelies on 28.03.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

internal protocol PlayerDiscoveryServiceDependenciesProtocol: HasReachabilityService {
    
}

internal struct PlayerDiscoveryServiceDependencies: PlayerDiscoveryServiceDependenciesProtocol {
    var reachabilityService: ReachabilityServiceProtocol
    
    init() {
        reachabilityService = ServiceFactory.makeReachabilityService()
    }
}
