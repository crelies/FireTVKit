//
//  FireTVSelectionDelegateProtocol.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright (c) 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

/// Protocol specifying the delegate methods called by the fire tv selection
///
public protocol FireTVSelectionDelegateProtocol: class {
    /// Method is called if a player is selected in the fire tv selection view
    ///
    /// - Parameters:
    ///   - fireTVSelectionViewController: corresponding fire tv selection view controller
    ///   - player: selected player
    ///
    func didSelectPlayer(_ fireTVSelectionViewController: FireTVSelectionViewController, player: RemoteMediaPlayer)
    /// Called if the close button is pressed in the fire tv selection view
    ///
    /// - Parameter fireTVSelectionViewController: corresponding fire tv selection view controller
    ///
    func didPressCloseButton(_ fireTVSelectionViewController: FireTVSelectionViewController)
}
