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
	/// Specifies the bar tint color of the navigation bar
	///
    var navigationBarBarTintColor: UIColor { get }
	/// Defines the background color of the view
	///
    var backgroundColor: UIColor { get }
	/// Describes the tint color of buttons
	///
    var buttonColor: UIColor { get }
	/// Specifies the color of the activity indicator view
	///
	var activityIndicatorViewColor: UIColor { get }
	/// Defines the background color of the table view cells
	/// representing the FireTVs
	///
    var cellBackgroundColor: UIColor { get }
	/// Specifies the text color of labels
	///
    var labelColor: UIColor { get }
	/// Defines the background color of the table view cell separators
	///
    var cellSeparatorColor: UIColor { get }
}
