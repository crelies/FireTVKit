//
//  PlayerServiceError.swift
//  FireTVKit
//
//  Created by crelies on 04.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

public enum PlayerServiceError: Error {
    case couldNotCastDurationToInt
    case couldNotCastPositionToInt64
    case couldNotCastTaskResultToMediaPlayerStatus
	case invalidTaskResult
}
