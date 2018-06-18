//
//  FireTVSelectionViewViewModel.swift
//  FireTVKit
//
//  Created by crelies on 23.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Represents the view model for the fire tv selection view
///
public struct FireTVSelectionViewViewModel {
	/// Declares if the close button is hidden
	///
	let isCloseButtonHidden: Bool
    /// Specifies if the table view is hidden
	///
    let isTableViewHidden: Bool
    /// Defines if the no devices label is hidden
	///
    let isNoDevicesLabelHidden: Bool
    /// Specifies if the activity indicator is hidden
	///
    let isActivityIndicatorViewHidden: Bool
}
