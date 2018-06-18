//
//  FireTVSelectionWireframeError.swift
//  FireTVKit
//
//  Created by crelies on 02.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Enum representing errors thrown by the `FireTVSelectionWireframe`
///
/// - couldNotFindResourceBundle: thrown if the resource bundle wasn't found
/// - couldNotInstantiateInitialViewController: thrown if the initial view controller couldn't be instantiated
/// - noViewControllersInNavigationController: thrown if outer navigation controller has no view controllers
///
public enum FireTVSelectionWireframeError: Error {
    case couldNotFindResourceBundle
    case couldNotInstantiateInitialViewController
    case noViewControllersInNavigationController
}
