//
//  PlayerDiscoveryControllerDelegateProtocol.swift
//  FireTVKit
//
//  Created by crelies on 04.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

protocol PlayerDiscoveryControllerDelegateProtocol: class {
	func deviceDiscovered(_ discoveryController: PlayerDiscoveryController, device: RemoteMediaPlayer)
	func deviceLost(_ discoveryController: PlayerDiscoveryController, device: RemoteMediaPlayer)
	func discoveryFailure(_ discoveryController: PlayerDiscoveryController)
}
