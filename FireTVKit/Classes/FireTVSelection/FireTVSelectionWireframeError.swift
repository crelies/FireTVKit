//
//  FireTVSelectionWireframeError.swift
//  FireTVKit
//
//  Created by crelies on 04.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

public enum FireTVSelectionWireframeError: Error {
	case couldNotFindBundle
	case couldNotInstantiateInitialViewController
	case noViewControllersInNavigationController
}
