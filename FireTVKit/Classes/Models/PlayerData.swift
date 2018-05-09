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
	
	init(status: MediaPlayerStatus, position: Int64) {
		self.status = PlayerStatus(rawValue: status.state().rawValue)
		self.position = position
	}
}

extension PlayerData: CustomStringConvertible {
	public var description: String {
        return "Status: [\(String(describing: status))], Position: [\(String(describing: position))]"
    }
}
