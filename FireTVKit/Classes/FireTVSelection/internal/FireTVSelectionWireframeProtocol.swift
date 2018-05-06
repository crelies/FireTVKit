//
//  FireTVSelectionWireframeProtocol.swift
//  FireTVKit
//
//  Created by crelies on 04.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

protocol FireTVSelectionWireframeProtocol {
    static func makeViewController(playerId: String, delegate: FireTVSelectionDelegateProtocol) throws -> UINavigationController
}
