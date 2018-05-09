//
//  FireTVPlayerPresenterDependencies.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

protocol FireTVPlayerPresenterDependenciesProtocol: TimeStringFactoryProvider {
    
}

struct FireTVPlayerPresenterDependencies: FireTVPlayerPresenterDependenciesProtocol {
    let timeStringFactory: TimeStringFactoryProtocol
    
    init() {
        timeStringFactory = ServiceFactory.makeTimeStringFactory()
    }
}
