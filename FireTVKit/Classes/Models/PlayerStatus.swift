//
//  PlayerStatus.swift
//  FireTVKit
//
//  Created by crelies on 04.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Enum describing all possible status of a player
///
public enum PlayerStatus: UInt32 {
    case noMedia = 0
    case preparingMedia
    case readyToPlay
    case playing
    case paused
    case seeking
    case finished
    case error
    
    /// Returns a string representation of the status
    ///
    public var stringValue: String {
        return String(describing: self)
    }
}
