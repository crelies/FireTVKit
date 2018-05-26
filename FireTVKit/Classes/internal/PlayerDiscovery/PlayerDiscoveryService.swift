//
//  PlayerDiscoveryService.swift
//  FireTVKit
//
//  Created by crelies on 27.03.2017.
//  Copyright © 2017 Christian Elies. All rights reserved.
//

import AmazonFling
import RxSwift
import UIKit

protocol HasPlayerDiscoveryService {
    var playerDiscoveryService: PlayerDiscoveryServiceProtocol { get }
}

protocol PlayerDiscoveryServiceProtocol {
    var devicesVariable: Variable<[RemoteMediaPlayer]?> { get }
	var devices: [RemoteMediaPlayer] { get }
	var discoveringInfo: Variable<DiscoveringInfo?> { get }
	
	init(dependencies: PlayerDiscoveryServiceDependenciesProtocol)
	func startDiscovering()
	func stopDiscovering()
}

final class PlayerDiscoveryService: PlayerDiscoveryServiceProtocol {
	private let dependencies: PlayerDiscoveryServiceDependenciesProtocol
	private(set) var devicesVariable: Variable<[RemoteMediaPlayer]?>
    var devices: [RemoteMediaPlayer] {
        return dependencies.playerDiscoveryController.devices
    }
	private(set) var discoveringInfo: Variable<DiscoveringInfo?>
    
	init(dependencies: PlayerDiscoveryServiceDependenciesProtocol) {
		self.dependencies = dependencies
        devicesVariable = Variable<[RemoteMediaPlayer]?>(nil)
		discoveringInfo = Variable<DiscoveringInfo?>(nil)
		
		var playerDiscoveryController = self.dependencies.playerDiscoveryController
		playerDiscoveryController.delegate = self
    }
	
	deinit {
        dependencies.logger.log(message: "PlayerDiscoveryService deinit", event: .info)
	}
	
	func startDiscovering() {
        devicesVariable.value = devices
	}
	
	func stopDiscovering() {
		devicesVariable.value = []
	}
}

extension PlayerDiscoveryService: PlayerDiscoveryControllerDelegateProtocol {
	func deviceDiscovered(_ discoveryController: PlayerDiscoveryControllerProtocol, device: RemoteMediaPlayer) {
		let discoveringInfo = DiscoveringInfo(device: device)
		self.discoveringInfo.value = discoveringInfo
		
		self.devicesVariable.value = devices
    }
    
	func deviceLost(_ discoveryController: PlayerDiscoveryControllerProtocol, device: RemoteMediaPlayer) {
        self.devicesVariable.value = devices
		
		let discoveringInfo = DiscoveringInfo(status: .deviceLost, device: device)
		self.discoveringInfo.value = discoveringInfo
    }
    
	func discoveryFailure(_ discoveryController: PlayerDiscoveryControllerProtocol) {
        dependencies.logger.log(message: "discovery failure", event: .error)
        let discoveringInfo = DiscoveringInfo(status: .discoveryFailure)
        self.discoveringInfo.value = discoveringInfo
    }
}
