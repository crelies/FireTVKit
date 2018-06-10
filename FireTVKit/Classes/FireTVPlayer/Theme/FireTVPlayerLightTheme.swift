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
	public let backgroundColor: UIColor
	public let closeButtonTintColor: UIColor
	public let labelColor: UIColor
	public let positionSliderTintColor: UIColor
    public let controlButtonTintColor: UIColor
    public let activityIndicatorViewColor: UIColor
	
	public init() {
		backgroundColor = .seafoam
		closeButtonTintColor = .deepAqua
		labelColor = .ocean
		positionSliderTintColor = .deepAqua
        controlButtonTintColor = .deepAqua
        activityIndicatorViewColor = .ocean
	}
}
