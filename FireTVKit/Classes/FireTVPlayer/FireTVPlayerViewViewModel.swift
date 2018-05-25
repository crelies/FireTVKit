//
//  FireTVPlayerViewViewModel.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

// TODO: activity indicator not visible if superview is not fullscreen
public struct FireTVPlayerViewViewModel {
	let isCloseButtonHidden: Bool
    let isPlayerControlEnabled: Bool
    let isActivityIndicatorViewHidden: Bool
    let isPositionStackViewHidden: Bool
    let isControlStackViewHidden: Bool
	let hideLabels: Bool
}
