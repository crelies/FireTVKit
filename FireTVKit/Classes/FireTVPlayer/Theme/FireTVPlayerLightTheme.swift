//
//  FireTVPlayerLightTheme.swift
//  FireTVKit
//
//  Created by crelies on 16.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Light theme for a fire tv player
///
public struct FireTVPlayerLightTheme: FireTVPlayerThemeProtocol {
    /// Color for the background of the view
    ///
    public let backgroundColor: UIColor
    /// Tint color for the close button of the player view
    ///
	public let closeButtonTintColor: UIColor
    /// Color to be used for labels
    ///
	public let labelColor: UIColor
    /// Tint color for a position slider if used
    ///
	public let positionSliderTintColor: UIColor
    /// Tint color for the control buttons, like play and pause
    ///
    public let controlButtonTintColor: UIColor
    /// Color of the activity indicator view
    ///
    public let activityIndicatorViewColor: UIColor
	
    /// Initializes the theme with the appropriate colors
    ///
	public init() {
		backgroundColor = .seafoam
		closeButtonTintColor = .deepAqua
		labelColor = .ocean
		positionSliderTintColor = .deepAqua
        controlButtonTintColor = .deepAqua
        activityIndicatorViewColor = .ocean
	}
}
