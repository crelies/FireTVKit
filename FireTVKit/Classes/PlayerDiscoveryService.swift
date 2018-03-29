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

internal protocol HasPlayerDiscoveryService {
    var playerDiscoveryService: PlayerDiscoveryServiceProtocol { get set }
}

internal protocol PlayerDiscoveryServiceProtocol {
	var devices: [RemoteMediaPlayer] { get }
	var deviceInfo: Variable<DeviceInfo?> { get }
	var discovering: Bool { get }
	var discoveringInfo: Variable<PlayerDiscoveringInfo?> { get }
	
	func startDiscovering()
	func stopDiscovering()
	func stopDiscovering(resetPlayer: Bool)
}

extension PlayerDiscoveryServiceProtocol {
	func stopDiscovering() {
		stopDiscovering(resetPlayer: false)
	}
}

internal final class PlayerDiscoveryService: PlayerDiscoveryServiceProtocol {
    private(set) var devices: [RemoteMediaPlayer]
	private(set) var deviceInfo: Variable<DeviceInfo?>
    private(set) var discovering: Bool
	private(set) var discoveringInfo: Variable<PlayerDiscoveringInfo?>
    
    fileprivate var discoveryController: DiscoveryController
	
	private let dependencies: PlayerDiscoveryServiceDependenciesProtocol
	private let disposeBag: DisposeBag
	private let playerServiceID: String
	private var discoveringStatus: DiscoveringStatus?
    
	init(dependencies: PlayerDiscoveryServiceDependenciesProtocol, with playerServiceID: String = "amzn.thin.pl") {
		self.dependencies = dependencies
		self.playerServiceID = playerServiceID
		
		devices = []
		deviceInfo = Variable<DeviceInfo?>(nil)
        discovering = false
		discoveringInfo = Variable<PlayerDiscoveringInfo?>(nil)
        
        discoveryController = DiscoveryController()
		
		disposeBag = DisposeBag()
		
		#if FIRETV
			discoveryController.searchPlayer(withId: playerServiceID, andListener: self)
			discoveringStatus = .started
		#endif
		
		dependencies.reachabilityService.reachabilityInfo.asObservable()
			.subscribe(onNext: { reachability in
				if let reachability = reachability {
					if reachability.connection == .wifi {
						self.startDiscovering()
					} else {
						self.stopDiscovering(resetPlayer: true)
					}
				}
			}).disposed(by: disposeBag)
    }
	
	func startDiscovering() {
		if discoveringStatus == .stopped {
			discoveringStatus = .started
			discoveryController.resume()
			
			let info = PlayerDiscoveringInfo(status: .started)
			discoveringInfo.value = info
		}
	}
	
	func stopDiscovering(resetPlayer: Bool = false) {
		if discoveringStatus == .started {
			discoveringStatus = .stopped
			discoveryController.close()
			devices.removeAll()
			
			let info = PlayerDiscoveringInfo(status: .stopped, resetPlayer: resetPlayer)
			discoveringInfo.value = info
		}
	}
}

extension PlayerDiscoveryService: DiscoveryListener {
    func deviceDiscovered(_ device: RemoteMediaPlayer!) {
        devices.append(device)
        
        let deadline = DispatchTime.now() + .seconds(3)
        DispatchQueue.global().asyncAfter(deadline: deadline) {
			let deviceInfo = DeviceInfo(device: device)
			self.deviceInfo.value = deviceInfo
        }
    }
    
    func deviceLost(_ device: RemoteMediaPlayer!) {
		if let index = devices.index (where: { $0.name() == device.name() }) {
			devices.remove(at: index)
		}
		
		let deviceInfo = DeviceInfo(status: .deviceLost, device: device)
		self.deviceInfo.value = deviceInfo
    }
    
    func discoveryFailure() {
		let info = PlayerDiscoveringInfo(status: .failed)
		discoveringInfo.value = info
    }
}
