//
//  FireTVSelectionPresenterDependencies.swift
//  FireTVKit
//
//  Created by crelies on 05.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

protocol FireTVSelectionPresenterDependenciesProtocol: LoggerProvider, ReachabilityServiceProvider {
    
}

struct FireTVSelectionPresenterDependencies: FireTVSelectionPresenterDependenciesProtocol {
    let logger: LoggerProtocol
    let reachabilityService: ReachabilityServiceProtocol
    
    init() throws {
        logger = ServiceFactory.makeLogger()
        reachabilityService = try ServiceFactory.makeReachabilityService()
    }
}
