//
//  PlayerDiscoveryControllerDependencies.swift
//  FireTVKit
//
//  Created by crelies on 26.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

protocol PlayerDiscoveryControllerDependenciesProtocol: LoggerProvider {
    
}

struct PlayerDiscoveryControllerDependencies: PlayerDiscoveryControllerDependenciesProtocol {
    let logger: LoggerProtocol
    
    init() {
        logger = ServiceFactory.makeLogger()
    }
}
