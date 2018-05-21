//
//  FireTVPlayerPresenterState.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

enum FireTVPlayerPresenterState {
    case connected
    case disconnected
    case loading
    case error(Error)
}

extension FireTVPlayerPresenterState: Equatable {
    static func == (lhs: FireTVPlayerPresenterState, rhs: FireTVPlayerPresenterState) -> Bool {
        switch (lhs, rhs) {
            case (.connected, .connected), (.disconnected, .disconnected), (.loading, .loading):
                return true
            case (.error(let lhsError), .error(let rhsError)):
                let lhsErr = lhsError as NSError
                let rhsErr = rhsError as NSError
                return lhsErr == rhsErr
            default:
                return false
        }
    }
}
