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
    
    public var devices: Observable<[RemoteMediaPlayer]?> {
        return dependencies.playerDiscoveryService.devicesVariable.asObservable()
    }
    
    public init() {
        dependencies = FireTVManagerDependencies()
    }
    
    public func startDiscovery(forPlayerID playerID: String) throws { // "amzn.thin.pl"
		var playerDiscoveryService = dependencies.playerDiscoveryService
        playerDiscoveryService.playerServiceID = playerID
		
        try dependencies.playerDiscoveryService.startDiscovering()
    }
    
    public func stopDiscovery() {
        dependencies.playerDiscoveryService.stopDiscovering()
    }
}
