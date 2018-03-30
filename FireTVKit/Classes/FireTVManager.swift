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
    private var dependencies: FireTVManagerDependenciesProtocol
    
    public var devices: Observable<[RemoteMediaPlayer]?> {
        return dependencies.playerDiscoveryService.devicesVariable.asObservable()
    }
    
    public init() {
        dependencies = FireTVManagerDependencies()
    }
    
    public func startDiscovery(forPlayerID playerID: String) { // "amzn.thin.pl"
        dependencies.playerDiscoveryService.playerServiceID = playerID
        dependencies.playerDiscoveryService.startDiscovering()
    }
    
    public func stopDiscovery() {
        dependencies.playerDiscoveryService.stopDiscovering()
    }
}
