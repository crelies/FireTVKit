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
///
public final class FireTVManager: FireTVManagerProtocol {
    private let dependencies: FireTVManagerDependenciesProtocol
	private let disposeBag: DisposeBag
    
    public var devicesObservable: Observable<[RemoteMediaPlayer]> {
        return dependencies.playerDiscoveryService.devicesObservable
    }
    public var devices: [RemoteMediaPlayer] {
        return dependencies.playerDiscoveryService.devices
    }
    
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
