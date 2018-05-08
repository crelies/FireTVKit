//
//  PlayerData.swift
//  FireTVKit
//
//  Created by crelies on 28.11.2017.
//  Copyright © 2017 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

public struct PlayerData {
	var position: Int64?
	var status: PlayerStatus?
	
	init() {}
	
	init(status: MediaPlayerStatus) {
        self.status = PlayerStatus(rawValue: status.state().rawValue)
	}
	
	init(status: MediaPlayerStatus, position: Int64) {
		self.status = PlayerStatus(rawValue: status.state().rawValue)
		self.position = position
	}
}

extension PlayerData: CustomStringConvertible {
	public var description: String {
        var positionString = "-"
        if let position = self.positionString {
            positionString = position
        }
        
        return "Status: [\(status)], Position: [\(positionString)]"
    }
}

extension PlayerData {
    var positionString: String? {
        guard let position = position else {
            return nil
        }
		
        let positionInSeconds = Int(position / 1000)
        let hours = Int(positionInSeconds / 60 / 60)
        let minutes = Int(positionInSeconds / 60) - (hours * 60)
        let seconds = Int(positionInSeconds) - (minutes * 60)
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
