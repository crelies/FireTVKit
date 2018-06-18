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
    /// Player currently has no media
    ///
    case noMedia = 0
    /// Player is preparing media for playback
    ///
    case preparingMedia
    /// Player is ready to play media
    ///
    case readyToPlay
    /// Player is playing media
    ///
    case playing
    /// Player playback is paused
    ///
    case paused
    /// Player is seeking
    ///
    case seeking
    /// Player playback has finished
    ///
    case finished
    /// Player has an error
    ///
    case error
    
    /// Returns a string representation of the status
    ///
    public var stringValue: String {
        return String(describing: self)
    }
}
