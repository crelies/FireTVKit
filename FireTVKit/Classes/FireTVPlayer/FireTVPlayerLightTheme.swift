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
	public let closeButtonTextColor: UIColor
	public let labelColor: UIColor
	public let positionSliderTintColor: UIColor
	
	public init() {
		backgroundColor = .init(red: 196/255.0, green: 223/255.0, blue: 230/255.0, alpha: 1)
		closeButtonTextColor = .init(red: 0/255.0, green: 59/255.0, blue: 70/255.0, alpha: 1)
		labelColor = .init(red: 0/255.0, green: 59/255.0, blue: 70/255.0, alpha: 1)
		positionSliderTintColor = .init(red: 0/255.0, green: 59/255.0, blue: 70/255.0, alpha: 1)
	}
}
