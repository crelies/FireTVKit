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
	var deviceInfo: Variable<DeviceInfo?> { get }
	
	init(dependencies: PlayerDiscoveryServiceDependenciesProtocol)
	func startDiscovering() throws
	func stopDiscovering()
}

final class PlayerDiscoveryService: PlayerDiscoveryServiceProtocol {
	private let dependencies: PlayerDiscoveryServiceDependenciesProtocol
	private(set) var devicesVariable: Variable<[RemoteMediaPlayer]?>
    var devices: [RemoteMediaPlayer] {
        return dependencies.playerDiscoveryController.devices
    }
	private(set) var deviceInfo: Variable<DeviceInfo?>
    
	init(dependencies: PlayerDiscoveryServiceDependenciesProtocol) {
		self.dependencies = dependencies
        devicesVariable = Variable<[RemoteMediaPlayer]?>(nil)
		deviceInfo = Variable<DeviceInfo?>(nil)
		
		var playerDiscoveryController = self.dependencies.playerDiscoveryController
		playerDiscoveryController.delegate = self
    }
	
	// TODO: remove me
	deinit {
		print("PlayerDiscoveryService deinit")
	}
	
	func startDiscovering() throws {
        devicesVariable.value = devices
	}
	
	func stopDiscovering() {
		devicesVariable.value = []
	}
}

extension PlayerDiscoveryService: PlayerDiscoveryControllerDelegateProtocol {
	func deviceDiscovered(_ discoveryController: PlayerDiscoveryController, device: RemoteMediaPlayer) {
		let deviceInfo = DeviceInfo(device: device)
		self.deviceInfo.value = deviceInfo
		
		self.devicesVariable.value = devices
    }
    
	func deviceLost(_ discoveryController: PlayerDiscoveryController, device: RemoteMediaPlayer) {
        self.devicesVariable.value = devices
		
		let deviceInfo = DeviceInfo(status: .deviceLost, device: device)
		self.deviceInfo.value = deviceInfo
    }
    
	func discoveryFailure(_ discoveryController: PlayerDiscoveryController) {
		// TODO: what to do?
        print("discovery failure")
    }
}
