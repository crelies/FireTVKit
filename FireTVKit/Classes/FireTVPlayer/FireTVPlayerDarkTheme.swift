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
	public let closeButtonTextColor: UIColor
	public let labelColor: UIColor
	public let positionSliderTintColor: UIColor
	
	public init() {
		backgroundColor = .init(red: 42/255.0, green: 49/255.0, blue: 50/255.0, alpha: 1)
		closeButtonTextColor = .init(red: 118/255.0, green: 54/255.0, blue: 38/255.0, alpha: 1)
		labelColor = .init(red: 118/255.0, green: 54/255.0, blue: 38/255.0, alpha: 1)
		positionSliderTintColor = .init(red: 118/255.0, green: 54/255.0, blue: 38/255.0, alpha: 1)
	}
}
