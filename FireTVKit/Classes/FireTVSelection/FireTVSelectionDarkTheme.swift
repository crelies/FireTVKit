//
//  FireTVSelectionDarkTheme.swift
//  FireTVKit
//
//  Created by crelies on 17.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

public struct FireTVSelectionDarkTheme: FireTVSelectionThemeProtocol {
    public let navigationBarBarTintColor: UIColor
    public let backgroundColor: UIColor
    public let closeBarButtonItemTintColor: UIColor
    public let cellBackgroundColor: UIColor
    public let cellLabelColor: UIColor
    public let cellSeparatorColor: UIColor
    
    public init() {
        navigationBarBarTintColor = .shadow
        backgroundColor = .shadow
        closeBarButtonItemTintColor = .autumnFoliage
        cellBackgroundColor = .clear
        cellLabelColor = .autumnFoliage
        cellSeparatorColor = .stone
    }
}
