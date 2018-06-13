//
//  FireTVPlayerViewViewModel.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Represents the view model for a fire tv player
///
public struct FireTVPlayerViewViewModel {
    /// Indicates if the close button is hidden
    ///
	let isCloseButtonHidden: Bool
    /// Defines if the player controls are enabled
    ///
    let isPlayerControlEnabled: Bool
    /// Indicates if the activity indicator is hidden
    ///
    let isActivityIndicatorViewHidden: Bool
    /// Defines if the position stack view with
    /// the position label, position slider and duration label is hidden
    ///
    let isPositionStackViewHidden: Bool
    /// Indicates if the stack view containing the control buttons (play, pause, etc.) is hidden
    ///
    let isControlStackViewHidden: Bool
    /// Defines if the labels for player name, media name and status are hidden
    ///
    let hideLabels: Bool
}
