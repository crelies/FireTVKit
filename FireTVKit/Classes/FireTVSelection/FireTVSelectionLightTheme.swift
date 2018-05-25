//
//  FireTVSelectionLightTheme.swift
//  FireTVKit
//
//  Created by crelies on 17.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

public struct FireTVSelectionLightTheme: FireTVSelectionThemeProtocol {
    public let navigationBarBarTintColor: UIColor
    public let backgroundColor: UIColor
	public let activityIndicatorViewColor: UIColor
    public let closeBarButtonItemTintColor: UIColor
    public let cellBackgroundColor: UIColor
    public let labelColor: UIColor
    public let cellSeparatorColor: UIColor
    
    public init() {
        navigationBarBarTintColor = .seafoam
        backgroundColor = .seafoam
		activityIndicatorViewColor = .ocean
        closeBarButtonItemTintColor = .ocean
        cellBackgroundColor = .clear
        labelColor = .ocean
        cellSeparatorColor = .stone
    }
}
