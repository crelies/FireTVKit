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
	let status: MediaPlayerStatus
	
	public init(status: MediaPlayerStatus) {
		self.status = status
	}
}
