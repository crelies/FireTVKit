//
//  FireTVPlayerThemeProtocol.swift
//  FireTVKit
//
//  Created by crelies on 12.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

public protocol FireTVPlayerThemeProtocol {
	var backgroundColor: UIColor { get }
	var closeButtonTintColor: UIColor { get }
	var labelColor: UIColor { get }
	var positionSliderTintColor: UIColor { get }
    var controlButtonTintColor: UIColor { get }
}
