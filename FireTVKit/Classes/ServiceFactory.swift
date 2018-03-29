//
//  ServiceFactory.swift
//  FireTVKit
//
//  Created by crelies on 29.03.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

internal protocol ServiceFactoryProtocol {
    static func makePlayerDiscoveryService() -> PlayerDiscoveryServiceProtocol
    static func makeReachabilityService() -> ReachabilityServiceProtocol
}

internal final class ServiceFactory: ServiceFactoryProtocol {
    private static var reachabilityService: ReachabilityServiceProtocol!
    private static var playerDiscoveryService: PlayerDiscoveryServiceProtocol!
    
    static func makeReachabilityService() -> ReachabilityServiceProtocol {
        if let reachabilityService = reachabilityService {
            return reachabilityService
        }
        
        reachabilityService = ReachabilityService()
        return reachabilityService
    }
    
    static func makePlayerDiscoveryService() -> PlayerDiscoveryServiceProtocol {
        if let playerDiscoveryService = playerDiscoveryService {
            return playerDiscoveryService
        }
        
        let dependencies = PlayerDiscoveryServiceDependencies()
        playerDiscoveryService = PlayerDiscoveryService(dependencies: dependencies)
        return playerDiscoveryService
    }
}
