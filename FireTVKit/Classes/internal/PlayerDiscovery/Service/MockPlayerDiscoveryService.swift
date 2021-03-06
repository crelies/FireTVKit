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
	private let devicesVariable: Variable<[RemoteMediaPlayer]?>
    private let discoveringInfo: Variable<DiscoveringInfo?>
    
    var devicesObservable: Observable<[RemoteMediaPlayer]> {
        return devicesVariable
            .asObservable()
            .flatMap { Observable.from(optional: $0) }
    }
	var devices: [RemoteMediaPlayer] {
		return dependencies.playerDiscoveryController.devices
	}
    var discoveringInfoObservable: Observable<DiscoveringInfo> {
        return discoveringInfo
            .asObservable()
            .flatMap { Observable.from(optional: $0) }
    }
	
	init(dependencies: PlayerDiscoveryServiceDependenciesProtocol) {
		self.dependencies = dependencies
		devicesVariable = Variable<[RemoteMediaPlayer]?>(nil)
		discoveringInfo = Variable<DiscoveringInfo?>(nil)
        
        var playerDiscoveryController = self.dependencies.playerDiscoveryController
        playerDiscoveryController.delegate = self
	}
	
	func startDiscovering() {
		let timeToWait = DispatchTime.now() + 1.5
		DispatchQueue.main.asyncAfter(deadline: timeToWait) { [weak self] in
			self?.devicesVariable.value = self?.devices
		}
	}
	
	func stopDiscovering() {
		devicesVariable.value = []
	}
}

extension MockPlayerDiscoveryService: PlayerDiscoveryControllerDelegateProtocol {
    func deviceDiscovered(_ discoveryController: PlayerDiscoveryControllerProtocol, device: RemoteMediaPlayer) {
        
    }
    
    func deviceLost(_ discoveryController: PlayerDiscoveryControllerProtocol, device: RemoteMediaPlayer) {
        
    }
    
    func discoveryFailure(_ discoveryController: PlayerDiscoveryControllerProtocol) {
        discoveringInfo.value = DiscoveringInfo(status: .discoveryFailure)
    }
}
