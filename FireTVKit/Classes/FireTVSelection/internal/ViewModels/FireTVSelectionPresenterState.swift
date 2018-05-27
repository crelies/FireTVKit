//
//  FireTVSelectionPresenterState.swift
//  FireTVKit
//
//  Created by crelies on 23.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

enum FireTVSelectionPresenterState {
    case loading
    case devicesFound
    case noDevices
}

extension FireTVSelectionPresenterState: Equatable {
    static func == (lhs: FireTVSelectionPresenterState, rhs: FireTVSelectionPresenterState) -> Bool {
        switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.devicesFound, .devicesFound):
                return true
            case (.noDevices, .noDevices):
                return true
            default:
                return false
        }
    }
}
