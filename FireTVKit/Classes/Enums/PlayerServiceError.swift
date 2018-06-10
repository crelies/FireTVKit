//
//  PlayerServiceError.swift
//  FireTVKit
//
//  Created by crelies on 04.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Enum of possible errors thrown by a `PlayerService` instance
///
/// - noPlayer: thrown if the player property is nil
/// - couldNotCastDurationToInt: thrown if a duration value could not be casted to `Int`
/// - couldNotCastPositionToInt64: thrown if a duration value could not be casted to `Int64`
/// - couldNotCastTaskResultToMediaPlayerStatus: thrown if a task result could not be casted to `MediaPlayerStatus`
/// - couldNotCastTaskResultToMediaPlayerInfo: thrown if a task result could not be casted to `MediaPlayerInfo`
/// - invalidTaskResult: thrown if a task result is invalid
/// - couldNotCreateStringFromMetadata: thrown if a string could not be created using metadata
///
public enum PlayerServiceError: Error {
    case noPlayer
    case couldNotCastDurationToInt
    case couldNotCastPositionToInt64
    case couldNotCastTaskResultToMediaPlayerStatus
    case couldNotCastTaskResultToMediaPlayerInfo
	case invalidTaskResult
    case couldNotCreateStringFromMetadata
}
