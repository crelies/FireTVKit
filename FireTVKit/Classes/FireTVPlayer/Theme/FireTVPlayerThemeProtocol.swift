//
//  FireTVPlayerThemeProtocol.swift
//  FireTVKit
//
//  Created by crelies on 12.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Protocol describing the requirements of a fire tv player theme
///
public protocol FireTVPlayerThemeProtocol {
    /// Color for the background of the view
    ///
	var backgroundColor: UIColor { get }
    /// Tint color for the close button of the player view
    ///
	var closeButtonTintColor: UIColor { get }
    /// Color to be used for labels
    ///
	var labelColor: UIColor { get }
    /// Tint color for a position slider if used
    ///
	var positionSliderTintColor: UIColor { get }
    /// Tint color for the control buttons, like play and pause
    ///
    var controlButtonTintColor: UIColor { get }
    /// Color of the activity indicator view
    ///
    var activityIndicatorViewColor: UIColor { get }
}
