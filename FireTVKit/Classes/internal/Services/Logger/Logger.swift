//
//  Logger.swift
//  FireTVKit
//
//  Created by crelies on 25.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

final class Logger: LoggerProtocol {
    static let dateFormat = IdentifierConstants.Date.logFormat
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    func log(message: String, event: LogEvent, fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        let isFireTVKitLoggingEnabled = UserDefaults.standard.value(forKey: IdentifierConstants.UserDefaults.Keys.fireTVKitLogging) as? Bool ?? false
        if isFireTVKitLoggingEnabled {
            let fireTVKitLogEventString = UserDefaults.standard.value(forKey: IdentifierConstants.UserDefaults.Keys.fireTVKitLogEvent) as? String ?? ""
            if let logEvent = LogEvent(rawValue: fireTVKitLogEventString) {
                if logEvent == event {
                    print("\(Date().stringValue) \(event.displayString)[\(sourceFileName(filePath: fileName))]:\(line) \(column) \(funcName) -> \(message)")
                }
            } else {
                print("\(Date().stringValue) \(event.displayString)[\(sourceFileName(filePath: fileName))]:\(line) \(column) \(funcName) -> \(message)")
            }
        }
    }
}

extension Logger {
    private func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last ?? ""
    }
}
