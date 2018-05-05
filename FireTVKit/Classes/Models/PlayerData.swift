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
	var duration: Int?
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
	
	init(duration: Int) {
		self.duration = duration
	}
}

extension PlayerData: CustomStringConvertible {
	public var description: String {
        var durationString = "-"
        if let duration = duration {
            durationString = "\(duration)"
        }
        
        var positionString = "-"
        if let position = self.positionString {
            positionString = position
        }
        
        return "Status: [\(status)], Duration: [\(durationString)], Position: [\(positionString)]"
    }
}

extension PlayerData {
    var positionString: String? {
        guard let position = position else {
            return nil
        }
        
        let hours = Int(position / (60 * 60))
        let minutes = Int((position / 60) % 60)
        let seconds = Int(position % 60)
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    var durationString: String? {
        guard let duration = duration else {
            return nil
        }
        
        let hours = Int(duration / (60 * 60))
        let minutes = Int((duration / 60) % 60)
        let seconds = Int(duration % 60)
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
