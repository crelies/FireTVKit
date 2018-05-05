//
//  FireTVPlayerInteractorDependencies.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

protocol FireTVPlayerInteractorDependenciesProtocol: PlayerServiceProvider {
    
}

struct FireTVPlayerInteractorDependencies: FireTVPlayerInteractorDependenciesProtocol {
    let playerService: PlayerServiceProtocol
    
    init() {
        playerService = ServiceFactory.makePlayerService()
    }
}
