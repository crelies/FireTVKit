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
    var playerServiceID: String? { get set }
	
	func startDiscovering() throws
	func stopDiscovering()
}

final class PlayerDiscoveryService: PlayerDiscoveryServiceProtocol {
    private(set) var devicesVariable: Variable<[RemoteMediaPlayer]?>
    private(set) var devices: [RemoteMediaPlayer]
	private(set) var deviceInfo: Variable<DeviceInfo?>
    var playerServiceID: String?
    
	init() {
        devicesVariable = Variable<[RemoteMediaPlayer]?>(nil)
		devices = []
		deviceInfo = Variable<DeviceInfo?>(nil)
		
		PlayerDiscoveryController.shared.delegate = self
    }
	
	// TODO: remove me
	deinit {
		print("PlayerDiscoveryService deinit")
	}
	
	func startDiscovering() throws {
		try PlayerDiscoveryController.shared.startSearch(forPlayerId: playerServiceID)
	}
	
	func stopDiscovering() {
		devices.removeAll()
		devicesVariable.value = devices
		
		PlayerDiscoveryController.shared.stopSearch()
	}
}

extension PlayerDiscoveryService: PlayerDiscoveryControllerDelegateProtocol {
	func deviceDiscovered(_ discoveryController: PlayerDiscoveryController, device: RemoteMediaPlayer) {
        devices.append(device)
		
		let deviceInfo = DeviceInfo(device: device)
		self.deviceInfo.value = deviceInfo
		
		self.devicesVariable.value = self.devices
    }
    
	func deviceLost(_ discoveryController: PlayerDiscoveryController, device: RemoteMediaPlayer) {
		if let index = devices.index (where: { $0.name() == device.name() }) {
			devices.remove(at: index)
            
            self.devicesVariable.value = self.devices
		}
		
		let deviceInfo = DeviceInfo(status: .deviceLost, device: device)
		self.deviceInfo.value = deviceInfo
    }
    
	func discoveryFailure(_ discoveryController: PlayerDiscoveryController) {
		// TODO: what to do?
    }
}
