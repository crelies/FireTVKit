//
//  FireTVPlayerViewProtocol.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Protocol describing the requirements of a fire tv player view
///
public protocol FireTVPlayerViewProtocol: class {
    func setPresenter(_ presenter: FireTVPlayerPresenterProtocol)
	func setTheme(_ theme: FireTVPlayerThemeProtocol)
	func setPlayerName(_ playerName: String)
    func setMediaName(_ mediaName: String)
    func setStatus(_ status: String)
    func setPositionText(_ positionText: String)
	func setPosition(_ position: Float)
    func setMaximumPosition(_ maximumPosition: Float)
    func setDurationText(_ durationText: String)
    func updateUI(withViewModel viewModel: FireTVPlayerViewViewModel)
	func updateUI(withViewModel viewModel: FireTVPlayerViewViewModel, animated: Bool)
    func updatePositionSliderUserInteractionEnabled(_ enabled: Bool)
}

extension FireTVPlayerViewProtocol {
    public func updateUI(withViewModel viewModel: FireTVPlayerViewViewModel) {
        updateUI(withViewModel: viewModel, animated: false)
    }
}
