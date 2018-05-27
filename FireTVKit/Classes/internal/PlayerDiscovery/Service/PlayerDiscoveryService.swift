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

protocol PlayerDiscoveryServiceProvider {
    var playerDiscoveryService: PlayerDiscoveryServiceProtocol { get }
}

protocol PlayerDiscoveryServiceProtocol {
    var devicesObservable: Observable<[RemoteMediaPlayer]> { get }
	var devices: [RemoteMediaPlayer] { get }
	var discoveringInfoObservable: Observable<DiscoveringInfo> { get }
	
	init(dependencies: PlayerDiscoveryServiceDependenciesProtocol)
	func startDiscovering()
	func stopDiscovering()
}

final class PlayerDiscoveryService: PlayerDiscoveryServiceProtocol {
	private let dependencies: PlayerDiscoveryServiceDependenciesProtocol
	private let devicesVariable: Variable<[RemoteMediaPlayer]?>
    private let discoveringInfoVariable: Variable<DiscoveringInfo?>
    
    var devicesObservable: Observable<[RemoteMediaPlayer]> {
        return devicesVariable
            .asObservable()
            .flatMap { Observable.from(optional: $0) }
    }
    var devices: [RemoteMediaPlayer] {
        return dependencies.playerDiscoveryController.devices
    }
    var discoveringInfoObservable: Observable<DiscoveringInfo> {
        return discoveringInfoVariable
            .asObservable()
            .flatMap { Observable.from(optional: $0) }
    }
    
	init(dependencies: PlayerDiscoveryServiceDependenciesProtocol) {
		self.dependencies = dependencies
        devicesVariable = Variable<[RemoteMediaPlayer]?>(nil)
		discoveringInfoVariable = Variable<DiscoveringInfo?>(nil)
		
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
		self.discoveringInfoVariable.value = discoveringInfo
		
		self.devicesVariable.value = devices
    }
    
	func deviceLost(_ discoveryController: PlayerDiscoveryControllerProtocol, device: RemoteMediaPlayer) {
        self.devicesVariable.value = devices
		
		let discoveringInfo = DiscoveringInfo(status: .deviceLost, device: device)
		self.discoveringInfoVariable.value = discoveringInfo
    }
    
	func discoveryFailure(_ discoveryController: PlayerDiscoveryControllerProtocol) {
        dependencies.logger.log(message: "discovery failure", event: .error)
        let discoveringInfo = DiscoveringInfo(status: .discoveryFailure)
        self.discoveringInfoVariable.value = discoveringInfo
    }
}
