//
//  FireTVPlayerPresenterProtocol.swift
//  FireTVKit
//
//  Created by crelies on 22.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Protocol describing the requirements of a `FireTVPlayerPresenter`
/// The presenter is responsible for a `FireTVViewProtocol` and needs to
/// be notified about certain actions happening in the view
/// Call the appropriate method if you implement a custom fire tv player view
///
public protocol FireTVPlayerPresenterProtocol: class {
    /// Tell the presenter that your view did load
	///
    func viewDidLoad()
    /// Tell the presenter that your view will appear
	///
    func viewWillAppear()
    /// Call this method to let the presenter do
	/// the necessary preparations for closing the view
	///
    func didPressCloseButton()
    /// Call this method if you want to rewind the player for 10 seconds
	///
    func didPressRewind10sButton()
    /// Call this method to send the play action to the player
	///
    func didPressPlayButton()
    /// Call this method to send the pause action to the player
	///
    func didPressPauseButton()
    ///  Call this method to send the stop action to the player
	///
    func didPressStopButton()
    ///  Call this method to fast forward the player for 10 seconds
	///
    func didPressFastForward10sButton()
    /// Updates the position label text using a position
    ///
    /// - Parameter position: the updated position
	///
    func didChangePositionValue(_ position: Float)
    /// Updates the playback position of the player
    ///
    /// - Parameter position: the new player position
	///
    func didChangePosition(_ position: Float)
}
