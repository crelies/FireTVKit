//
//  MockPlayerDiscoveryService.swift
//  FireTVKit
//
//  Created by crelies on 17.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation
import RxSwift

final class MockPlayerDiscoveryService: PlayerDiscoveryServiceProtocol {
	private let dependencies: PlayerDiscoveryServiceDependenciesProtocol
	var devicesVariable: Variable<[RemoteMediaPlayer]?>
	var devices: [RemoteMediaPlayer] {
		return dependencies.playerDiscoveryController.devices
	}
	var deviceInfo: Variable<DeviceInfo?>
	
	init(dependencies: PlayerDiscoveryServiceDependenciesProtocol) {
		self.dependencies = dependencies
		devicesVariable = Variable<[RemoteMediaPlayer]?>(nil)
		deviceInfo = Variable<DeviceInfo?>(nil)
	}
	
	func startDiscovering() throws {
		
	}
	
	func stopDiscovering() {
		
	}
}
