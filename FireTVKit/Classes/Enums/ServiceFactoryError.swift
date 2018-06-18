//
//  ServiceFactoryError.swift
//  FireTVKit
//
//  Created by crelies on 27.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Enum of possible errors thrown by the `ServiceFactory`
///
/// - couldNotCreateReachabilityService: thrown if a `ReachabilityService` instance could not be created
///
public enum ServiceFactoryError: Error {
    case couldNotCreateReachabilityService
}
