//
//  PlayerStatus.swift
//  FireTVKit
//
//  Created by crelies on 04.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

internal enum PlayerStatus: UInt32 {
    case noMedia = 0
    case preparingMedia
    case readyToPlay
    case playing
    case paused
    case seeking
    case finished
    case error
}
