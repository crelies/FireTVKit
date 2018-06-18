//
//  LoggerProtocol.swift
//  FireTVKit
//
//  Created by crelies on 25.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Protocol describing the requirements for a `Logger`
///
public protocol LoggerProtocol {
    func log(message: String, event: LogEvent)
    /// Method which logs a message
    ///
    /// - Parameters:
    ///   - message: message to be logged
    ///   - event: event type for the message
    ///   - fileName: name of the file in which the log was initiated
    ///   - line: specifies the line in which the log was initiated
    ///   - column: defines the column in which the log was initiated
    ///   - funcName: specifies the name of the function in which the log was initiated
    ///
    func log(message: String, event: LogEvent, fileName: String, line: Int, column: Int, funcName: String)
}

extension LoggerProtocol {
    /// Default implementation of the `log` method
    /// Uses the current file, current line, current column and current function
    /// as default parameter values
    ///
    /// - Parameters:
    ///   - message: message to be logged
    ///   - event: event type for the message
    ///
    func log(message: String, event: LogEvent) {
        log(message: message, event: event, fileName: #file, line: #line, column: #column, funcName: #function)
    }
}
