//
//  PlayerData.swift
//  FireTVKit
//
//  Created by crelies on 28.11.2017.
//  Copyright © 2017 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

extension Int64 {
    var position: String {
        let hours = Int(self / (60 * 60))
        let minutes = Int((self / 60) % 60)
        let seconds = Int(self % 60)
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

public struct PlayerData {
	var duration: Int?
	var position: Int64?
	let status: MediaPlayerStatus
	
	public init(status: MediaPlayerStatus) {
		self.status = status
	}
}

extension PlayerData: CustomStringConvertible {
    public var description: String {
        var durationString = "-"
        if let duration = duration {
            durationString = "\(duration)"
        }
        
        var positionString = "-"
        if let position = position {
            positionString = position.position
        }
        
        return "Status: [\(status.state())], Duration: [\(durationString)], Position: [\(positionString)]"
    }
}
