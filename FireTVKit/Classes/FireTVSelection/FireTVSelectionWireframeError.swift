//
//  FireTVSelectionWireframeError.swift
//  FireTVKit
//
//  Created by crelies on 02.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

public enum FireTVSelectionWireframeError: Error {
    case couldNotFindResourceBundle
    case couldNotInstantiateInitialViewController
    case noViewControllersInNavigationController
}
