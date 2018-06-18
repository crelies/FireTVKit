//
//  StringConstants.swift
//  FireTVKit
//
//  Created by crelies on 26.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

struct StringConstants {
    struct Alert {
        struct Title {
            static let error = "Error"
        }
        
        struct Message {
            static let discoveryFailure = "A discovery failure occurred. View will be closed."
            static let noWifi = "You are not connected to a wifi network. The connection is required."
        }
    }
    
    struct FireTVSelection {
        static let noDevices = "No devices found"
    }
    
    struct Labels {
        static let ok = "OK"
    }
}
