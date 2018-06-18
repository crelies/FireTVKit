//
//  FireTVPlayerPresenterDependencies.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

protocol FireTVPlayerPresenterDependenciesProtocol: TimeStringFactoryProvider, LoggerProvider, ReachabilityServiceProvider {
    
}

struct FireTVPlayerPresenterDependencies: FireTVPlayerPresenterDependenciesProtocol {
    let timeStringFactory: TimeStringFactoryProtocol
    let logger: LoggerProtocol
    let reachabilityService: ReachabilityServiceProtocol
    
    init() throws {
        timeStringFactory = ServiceFactory.makeTimeStringFactory()
        logger = ServiceFactory.makeLogger()
        reachabilityService = try ServiceFactory.makeReachabilityService()
    }
}
