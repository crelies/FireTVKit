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
    
    static func makePlayerService() -> PlayerServiceProtocol {
        return PlayerService(withPlayer: nil)
    }
    
    public static func makePlayerService(withPlayer player: RemoteMediaPlayer) -> PlayerServiceProtocol {
        return PlayerService(withPlayer: player)
    }
    
	static func makeReachabilityService() -> ReachabilityServiceProtocol? {
        return ReachabilityService()
    }
}
