//
//  FireTVPlayerWireframeError.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Enum for the possible errors thrown by the `FireTVPlayerWireframe`
///
/// - couldNotFindResourceBundle: thrown if the resource bundle wasn't found
/// - couldNotInstantiateInitialViewController: thrown if the initial view controller couldn't be instantiated
///
public enum FireTVPlayerWireframeError: Error {
    case couldNotFindResourceBundle
    case couldNotInstantiateInitialViewController
}
