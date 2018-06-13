//
//  FireTVPlayerDelegateProtocol.swift
//  FireTVKit
//
//  Created by crelies on 08.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Protocol describing the delegate methods of a fire tv player
///
public protocol FireTVPlayerDelegateProtocol: class {
    /// Will be called if the close button of a `FireTVPlayerViewProtocol` is tapped
    ///
    /// - Parameter fireTVPlayerViewController: the corresponding view controller instance
	///
    func didPressCloseButton(_ fireTVPlayerViewController: FireTVPlayerViewController)
}
