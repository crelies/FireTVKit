//
//  FireTVSelectionLightTheme.swift
//  FireTVKit
//
//  Created by crelies on 17.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Light theme for the fire tv selection
///
public struct FireTVSelectionLightTheme: FireTVSelectionThemeProtocol {
	/// Specifies the bar tint color of the navigation bar
	///
    public let navigationBarBarTintColor: UIColor
	/// Defines the background color of the view
	///
    public let backgroundColor: UIColor
	/// Describes the tint color of buttons
	///
    public let buttonColor: UIColor
	/// Specifies the color of the activity indicator view
	///
	public let activityIndicatorViewColor: UIColor
	/// Defines the background color of the table view cells
	/// representing the FireTVs
	///
    public let cellBackgroundColor: UIColor
	/// Specifies the text color of labels
	///
    public let labelColor: UIColor
	/// Defines the background color of the table view cell separators
	///
    public let cellSeparatorColor: UIColor
    
	/// Initializes the light theme
	///
    public init() {
        navigationBarBarTintColor = .seafoam
        backgroundColor = .seafoam
        buttonColor = .deepAqua
		activityIndicatorViewColor = .ocean
        cellBackgroundColor = .clear
        labelColor = .ocean
        cellSeparatorColor = .ocean
    }
}
