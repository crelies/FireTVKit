//
//  LoggerProtocol.swift
//  FireTVKit
//
//  Created by crelies on 25.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

public protocol LoggerProtocol {
    func log(message: String, event: LogEvent)
    func log(message: String, event: LogEvent, fileName: String, line: Int, column: Int, funcName: String)
}

extension LoggerProtocol {
    func log(message: String, event: LogEvent) {
        log(message: message, event: event, fileName: #file, line: #line, column: #column, funcName: #function)
    }
}
