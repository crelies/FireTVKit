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
	static func makePlayerDiscoveryController() -> PlayerDiscoveryControllerProtocol {
		return PlayerDiscoveryController.shared
	}
	
    static func makePlayerDiscoveryService() -> PlayerDiscoveryServiceProtocol {
		let dependencies = PlayerDiscoveryServiceDependencies()
		return PlayerDiscoveryService(dependencies: dependencies)
    }
    
    static func makePlayerService() -> PlayerServiceProtocol {
        let dependencies = PlayerServiceDependencies()
        return PlayerService(dependencies: dependencies, withPlayer: nil)
    }
    
    public static func makePlayerService(withPlayer player: RemoteMediaPlayer) -> PlayerServiceProtocol {
        let dependencies = PlayerServiceDependencies()
        return PlayerService(dependencies: dependencies, withPlayer: player)
    }
    
	static func makeReachabilityService() -> ReachabilityServiceProtocol? {
        return ReachabilityService()
    }
    
    static func makeTimeStringFactory() -> TimeStringFactoryProtocol {
        return TimeStringFactory()
    }
    
    static func makeLogger() -> LoggerProtocol {
        return Logger()
    }
}
