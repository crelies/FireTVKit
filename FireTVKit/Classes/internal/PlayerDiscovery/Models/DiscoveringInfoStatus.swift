//
//  DiscoveringInfoStatus.swift
//  FireTVKit
//
//  Created by crelies on 28.03.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

enum DiscoveringInfoStatus {
    case deviceDiscovered
    case deviceLost
    case discoveryFailure
}

extension DiscoveringInfoStatus: Equatable {
    static func == (lhs: DiscoveringInfoStatus, rhs: DiscoveringInfoStatus) -> Bool {
        switch (lhs, rhs) {
            case (.deviceDiscovered, .deviceDiscovered):
                return true
            case (.deviceLost, .deviceLost):
                return true
            case (.discoveryFailure, .discoveryFailure):
                return true
            default:
                return false
        }
    }
}
