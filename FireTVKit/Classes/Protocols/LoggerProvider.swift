//
//  LoggerProvider.swift
//  FireTVKit
//
//  Created by crelies on 25.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Protocol declaring the use of a logger
///
public protocol LoggerProvider {
    var logger: LoggerProtocol { get }
}
