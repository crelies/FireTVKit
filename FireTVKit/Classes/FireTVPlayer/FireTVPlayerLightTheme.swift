//
//  FireTVPlayerLightTheme.swift
//  FireTVKit
//
//  Created by crelies on 16.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

public struct FireTVPlayerLightTheme: FireTVPlayerThemeProtocol {
	public let backgroundColor: UIColor
	public let closeButtonTintColor: UIColor
	public let labelColor: UIColor
	public let positionSliderTintColor: UIColor
    public let controlButtonTintColor: UIColor
    public let activityIndicatorViewColor: UIColor
	
	public init() {
		backgroundColor = .seafoam
		closeButtonTintColor = .ocean
		labelColor = .ocean
		positionSliderTintColor = .ocean
        controlButtonTintColor = .ocean
        activityIndicatorViewColor = .ocean
	}
}
