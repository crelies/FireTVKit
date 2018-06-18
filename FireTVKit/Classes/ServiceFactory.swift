//
//  ServiceFactory.swift
//  FireTVKit
//
//  Created by crelies on 29.03.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

/// Factory for creating services used by FireTVKit
/// Most services the factory creates are internal
/// Only the method for creating a player service is public
///
public final class ServiceFactory: ServiceFactoryProtocol {
	static func makePlayerDiscoveryController() -> PlayerDiscoveryControllerProtocol {
		let playerDiscoveryController = PlayerDiscoveryController.shared
        let dependencies = PlayerDiscoveryControllerDependencies()
        playerDiscoveryController.dependencies = dependencies
        return playerDiscoveryController
	}
	
    static func makePlayerDiscoveryService() -> PlayerDiscoveryServiceProtocol {
		let dependencies = PlayerDiscoveryServiceDependencies()
		return PlayerDiscoveryService(dependencies: dependencies)
    }
    
    static func makePlayerService() -> PlayerServiceProtocol {
        let dependencies = PlayerServiceDependencies()
        return PlayerService(dependencies: dependencies, withPlayer: nil)
    }
    
    /// Makes a player service for the given player
    ///
    /// - Parameter player: the player you want to control
    /// - Returns: a player service instance conforming to the `PlayerServiceProtocol`
    ///
    public static func makePlayerService(withPlayer player: RemoteMediaPlayer) -> PlayerServiceProtocol {
        let dependencies = PlayerServiceDependencies()
        return PlayerService(dependencies: dependencies, withPlayer: player)
    }
    
    static func makeTimeStringFactory() -> TimeStringFactoryProtocol {
        return TimeStringFactory()
    }
    
    static func makeLogger() -> LoggerProtocol {
        return Logger()
    }
    
    static func makeReachabilityService() throws -> ReachabilityServiceProtocol {
        guard let service = ReachabilityService() else {
            throw ServiceFactoryError.couldNotCreateReachabilityService
        }
        return service
    }
}
