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
	func deviceDiscovered(_ discoveryController: PlayerDiscoveryControllerProtocol, device: RemoteMediaPlayer)
	func deviceLost(_ discoveryController: PlayerDiscoveryControllerProtocol, device: RemoteMediaPlayer)
	func discoveryFailure(_ discoveryController: PlayerDiscoveryControllerProtocol)
}
