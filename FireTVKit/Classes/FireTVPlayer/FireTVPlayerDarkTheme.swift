//
//  FireTVPlayerDarkTheme.swift
//  FireTVKit
//
//  Created by crelies on 16.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

public struct FireTVPlayerDarkTheme: FireTVPlayerThemeProtocol {
	public let backgroundColor: UIColor
	public let closeButtonTintColor: UIColor
	public let labelColor: UIColor
	public let positionSliderTintColor: UIColor
    public let controlButtonTintColor: UIColor
	
	public init() {
		backgroundColor = .shadow
		closeButtonTintColor = .stone
		labelColor = .autumnFoliage
		positionSliderTintColor = .stone
        controlButtonTintColor = .stone
	}
}
