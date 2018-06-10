//
//  FireTVSelectionDarkTheme.swift
//  FireTVKit
//
//  Created by crelies on 17.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Dark theme for the fire tv selection
///
public struct FireTVSelectionDarkTheme: FireTVSelectionThemeProtocol {
    public let navigationBarBarTintColor: UIColor
    public let backgroundColor: UIColor
    public let buttonColor: UIColor
	public let activityIndicatorViewColor: UIColor
    public let cellBackgroundColor: UIColor
    public let labelColor: UIColor
    public let cellSeparatorColor: UIColor
    
    public init() {
        navigationBarBarTintColor = .shadow
        backgroundColor = .shadow
        buttonColor = .stone
		activityIndicatorViewColor = .autumnFoliage
        cellBackgroundColor = .clear
        labelColor = .autumnFoliage
        cellSeparatorColor = .autumnFoliage
    }
}
