//
//  FireTVPlayerViewProtocol.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Protocol describing the requirements of a fire tv player view
/// Implement this protocol if you want to create your custom player view
/// Set it up using the `configure` method of the `FireTVPlayerWireframe`
///
public protocol FireTVPlayerViewProtocol: class {
    /// Method is called inside wireframe methods
    /// Store the presenter in a property inside your custom view
    /// That way you can notify the presenter about actions happening in the view
    ///
    /// - Parameter presenter: related presenter
    ///
    func setPresenter(_ presenter: FireTVPlayerPresenterProtocol)
    /// Method will be called from the presenter
    /// Use the theme to style your view
    ///
    /// - Parameter theme: theme for styling your view
    ///
	func setTheme(_ theme: FireTVPlayerThemeProtocol)
    /// Called from the presenter to notify you about the player name
    ///
    /// - Parameter playerName: the name of the player
    ///
	func setPlayerName(_ playerName: String)
    /// Method will be called from the presenter to tell the
    /// view the name of the currently playing media
    ///
    /// - Parameter mediaName: name of the media playing
    ///
    func setMediaName(_ mediaName: String)
    /// Notifies about the current player status
    ///
    /// - Parameter status: the current player status
    ///
    func setStatus(_ status: String)
    /// Tells the view about the current position text
    ///
    /// - Parameter positionText: the current position text of the player, for example 00:04:34
    ///
    func setPositionText(_ positionText: String)
    /// Notifies the view about the current position in milliseconds
    ///
    /// - Parameter position: the current position
    ///
	func setPosition(_ position: Float)
    /// Passes the maximum position (duration of the currently playing media) to the view
    ///
    /// - Parameter maximumPosition: the maximum position
    ///
    func setMaximumPosition(_ maximumPosition: Float)
    /// Notifies the view about the duration text of the currently playing media, for example 01:36:40
    ///
    /// - Parameter durationText: the duration text of the playing media
    ///
    func setDurationText(_ durationText: String)
    /// Presenter calls this method to trigger an ui update without animation
    ///
    /// - Parameter viewModel: view model for the ui update
    ///
    func updateUI(withViewModel viewModel: FireTVPlayerViewViewModel)
    /// Presenter calls this method to trigger an ui update with or without animation
    ///
    /// - Parameters:
    ///   - viewModel: view model for the ui update
    ///   - animated: boolean value indicating if the ui update should animate
    ///
	func updateUI(withViewModel viewModel: FireTVPlayerViewViewModel, animated: Bool)
    /// Presenter calls this method to enable or disable the user interaction of a slider
    /// representing the position of the currently playing media
    ///
    /// - Parameter enabled: boolean value indicating if user interaction is enabled or not
    ///
    func updatePositionSliderUserInteractionEnabled(_ enabled: Bool)
}

extension FireTVPlayerViewProtocol {
    /// Presenter calls this method to trigger an ui update without animation
    ///
    /// - Parameter viewModel: view model for the ui update
    ///
    public func updateUI(withViewModel viewModel: FireTVPlayerViewViewModel) {
        updateUI(withViewModel: viewModel, animated: false)
    }
}
