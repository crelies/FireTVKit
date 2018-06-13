//
//  FireTVManager.swift
//  FireTVKit
//
//  Created by crelies on 30.03.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation
import RxSwift

/// Responsible for discovering FireTVs in your local network
/// Observe the `devicesObservable` to be notified about changes
/// to the internal devices list (device discovered or device lost)
///
public final class FireTVManager: FireTVManagerProtocol {
    private let dependencies: FireTVManagerDependenciesProtocol
	private let disposeBag: DisposeBag
    
    /// Observe the internal devices list using this observable
	///
    public var devicesObservable: Observable<[RemoteMediaPlayer]> {
        return dependencies.playerDiscoveryService.devicesObservable
    }
    /// Get the current devices list
	///
    public var devices: [RemoteMediaPlayer] {
        return dependencies.playerDiscoveryService.devices
    }
    
    /// Initializes a `FireTVManager` instance
	/// All the magic (reachability and discovery setup) happens
	/// under the hood
    ///
	/// - Throws: an error if the internal reachability service couldn't be initialized
	///
    public init() throws {
        dependencies = try FireTVManagerDependencies()
		disposeBag = DisposeBag()
    }
    
    /// Starts discovery in your local network
    ///
    /// - Parameter playerID: playerID to be searched
    /// - Throws: error if reachability service failed to start listening
    ///
    public func startDiscovery(forPlayerID playerID: String) throws {
		dependencies.reachabilityService.reachabilityObservable
			.subscribe(onNext: { [weak self] reachability in
				if reachability.connection == .wifi {
					self?.dependencies.playerDiscoveryService.startDiscovering()
					self?.dependencies.playerDiscoveryController.startSearch(forPlayerId: playerID)
				} else {
					self?.stopDiscovery()
				}
			}).disposed(by: disposeBag)
		
		try dependencies.reachabilityService.startListening()
    }
    
    /// Stops discovery in your local network
    ///
    public func stopDiscovery() {
        dependencies.playerDiscoveryService.stopDiscovering()
        dependencies.playerDiscoveryController.stopSearch()
    }
}
