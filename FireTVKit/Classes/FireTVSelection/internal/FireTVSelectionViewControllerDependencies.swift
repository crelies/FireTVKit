//
//  FireTVSelectionViewControllerDependencies.swift
//  FireTVKit
//
//  Created by crelies on 25.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

struct FireTVSelectionViewControllerDependencies: FireTVSelectionViewControllerDependenciesProtocol {
    let logger: LoggerProtocol
    
    init() {
        logger = ServiceFactory.makeLogger()
    }
}
