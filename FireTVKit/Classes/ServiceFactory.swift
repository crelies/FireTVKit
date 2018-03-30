//
//  ServiceFactory.swift
//  FireTVKit
//
//  Created by crelies on 29.03.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

public final class ServiceFactory: ServiceFactoryProtocol {
    static func makePlayerDiscoveryService() -> PlayerDiscoveryServiceProtocol {
        return PlayerDiscoveryService()
    }
    
    public static func makePlayerService(withPlayer player: RemoteMediaPlayer) -> PlayerServiceProtocol {
        return PlayerService(player: player)
    }
    
    public static func makeReachabilityService() -> ReachabilityServiceProtocol? {
        return ReachabilityService()
    }
}
