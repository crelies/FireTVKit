//
//  MockPlayerDiscoveryController.swift
//  FireTVKit
//
//  Created by crelies on 17.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

final class MockPlayerDiscoveryController: PlayerDiscoveryControllerProtocol {
	static let shared = MockPlayerDiscoveryController()
	
	private(set) var devices: [RemoteMediaPlayer]
	weak var delegate: PlayerDiscoveryControllerDelegateProtocol?
	
	private init() {
		devices = [DummyPlayer()]
	}
	
	func startSearch(forPlayerId playerId: String?) {
		
	}
	
	func stopSearch() {
		
	}
}
