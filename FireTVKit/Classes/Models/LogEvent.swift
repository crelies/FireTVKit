//
//  LogEvent.swift
//  FireTVKit
//
//  Created by crelies on 25.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

public enum LogEvent: String {
    case error
    case info
    case debug
    case verbose
    case warning
    case severe
    
    var displayString: String {
        switch self {
            case .error:
                return "[‼️]"
            case .info:
                return "[ℹ️]"
            case .debug:
                return "[💬]"
            case .verbose:
                return "[🔬]"
            case .warning:
                return "[⚠️]"
            case .severe:
                return "[🔥]"
        }
    }
}
