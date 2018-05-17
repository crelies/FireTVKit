//
//  MockServiceFactory.swift
//  FireTVKit
//
//  Created by crelies on 17.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

final class MockServiceFactory: ServiceFactoryProtocol {
	static func makePlayerDiscoveryController() -> PlayerDiscoveryControllerProtocol {
		return MockPlayerDiscoveryController.shared
	}
	
	static func makePlayerDiscoveryService() -> PlayerDiscoveryServiceProtocol {
		let dependencies = MockPlayerDiscoveryServiceDependencies()
		return MockPlayerDiscoveryService(dependencies: dependencies)
	}
	
	static func makePlayerService() -> PlayerServiceProtocol {
		return MockPlayerService(withPlayer: nil)
	}
	
	static func makePlayerService(withPlayer player: RemoteMediaPlayer) -> PlayerServiceProtocol {
		return MockPlayerService(withPlayer: player)
	}
	
	static func makeReachabilityService() -> ReachabilityServiceProtocol? {
		// TODO:
		return ReachabilityService()
	}
	
	static func makeTimeStringFactory() -> TimeStringFactoryProtocol {
		return TimeStringFactory()
	}
}
