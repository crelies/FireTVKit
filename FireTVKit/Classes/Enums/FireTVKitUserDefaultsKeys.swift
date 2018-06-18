//
//  FireTVKitUserDefaultsKeys.swift
//  FireTVKit
//
//  Created by crelies on 06.06.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// String enum used for storing data in UserDefaults
///
/// - fireTVKitLogging: boolean value which specifies if logging is enabled for the FireTVKit
/// - fireTVKitLogEvent: string value describing which specific event type should be logged
///
public enum FireTVKitUserDefaultsKeys: String {
    case fireTVKitLogging
    case fireTVKitLogEvent
}
