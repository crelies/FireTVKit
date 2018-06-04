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
    
    public func stopDiscovery() {
        dependencies.playerDiscoveryService.stopDiscovering()
        dependencies.playerDiscoveryController.stopSearch()
    }
}
