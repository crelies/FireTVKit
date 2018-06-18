//
//  MockPlayerServiceDependencies.swift
//  FireTVKit
//
//  Created by crelies on 25.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

struct MockPlayerServiceDependencies: PlayerServiceDependenciesProtocol {
    let logger: LoggerProtocol
    
    init() {
        logger = MockServiceFactory.makeLogger()
    }
}
