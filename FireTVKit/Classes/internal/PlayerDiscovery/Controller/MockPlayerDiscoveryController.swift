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
	
    var dependencies: PlayerDiscoveryControllerDependenciesProtocol?
	var devices: [RemoteMediaPlayer] {
        if diceRollEnabled {
            let diceRoll = Int(arc4random_uniform(2))
            if diceRoll == 0 {
                return []
            } else {
                return [DummyPlayer()]
            }
        } else {
            return [DummyPlayer()]
        }
	}
	weak var delegate: PlayerDiscoveryControllerDelegateProtocol?
    var diceRollEnabled = true
	
	private init() {
		
	}
	
	func startSearch(forPlayerId playerId: String?) {
		
	}
	
	func stopSearch() {
		
	}
}
