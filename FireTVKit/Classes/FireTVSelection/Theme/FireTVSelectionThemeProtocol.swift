//
//  FireTVSelectionThemeProtocol.swift
//  FireTVKit
//
//  Created by crelies on 12.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Protocol describing the requirements for a fire tv selection theme
///
public protocol FireTVSelectionThemeProtocol {
    var navigationBarBarTintColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var buttonColor: UIColor { get }
	var activityIndicatorViewColor: UIColor { get }
    var cellBackgroundColor: UIColor { get }
    var labelColor: UIColor { get }
    var cellSeparatorColor: UIColor { get }
}
