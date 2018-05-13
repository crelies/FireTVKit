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
    var devicesVariable: Variable<[RemoteMediaPlayerProtocol]?> { get }
	var devices: [RemoteMediaPlayerProtocol] { get }
	var deviceInfo: Variable<DeviceInfo?> { get }
	
	func startDiscovering() throws
	func stopDiscovering()
}

final class PlayerDiscoveryService: PlayerDiscoveryServiceProtocol {
    private(set) var devicesVariable: Variable<[RemoteMediaPlayerProtocol]?>
    var devices: [RemoteMediaPlayerProtocol] {
        return PlayerDiscoveryController.shared.devices
    }
	private(set) var deviceInfo: Variable<DeviceInfo?>
    
	init() {
        devicesVariable = Variable<[RemoteMediaPlayerProtocol]?>(nil)
		deviceInfo = Variable<DeviceInfo?>(nil)
		
		PlayerDiscoveryController.shared.delegate = self
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
	func deviceDiscovered(_ discoveryController: PlayerDiscoveryController, device: RemoteMediaPlayerProtocol) {
		let deviceInfo = DeviceInfo(device: device)
		self.deviceInfo.value = deviceInfo
		
		self.devicesVariable.value = devices
    }
    
	func deviceLost(_ discoveryController: PlayerDiscoveryController, device: RemoteMediaPlayerProtocol) {
        self.devicesVariable.value = devices
		
		let deviceInfo = DeviceInfo(status: .deviceLost, device: device)
		self.deviceInfo.value = deviceInfo
    }
    
	func discoveryFailure(_ discoveryController: PlayerDiscoveryController) {
		// TODO: what to do?
        print("discovery failure")
    }
}
