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
    var devicesVariable: Variable<[RemoteMediaPlayer]?> { get }
	var devices: [RemoteMediaPlayer] { get }
	var deviceInfo: Variable<DeviceInfo?> { get }
	var discovering: Bool { get }
	var discoveringInfo: Variable<PlayerDiscoveringInfo?> { get }
    var playerServiceID: String? { get set }
	
	func startDiscovering()
	func stopDiscovering()
}

internal final class PlayerDiscoveryService: PlayerDiscoveryServiceProtocol {
    private(set) var devicesVariable: Variable<[RemoteMediaPlayer]?>
    private(set) var devices: [RemoteMediaPlayer]
	private(set) var deviceInfo: Variable<DeviceInfo?>
    private(set) var discovering: Bool
	private(set) var discoveringInfo: Variable<PlayerDiscoveringInfo?>
    
    private var discoveryController: DiscoveryController
	
	private let disposeBag: DisposeBag
	private var discoveringStatus: DiscoveringStatus
    
    var playerServiceID: String?
    
	init() {
        devicesVariable = Variable<[RemoteMediaPlayer]?>(nil)
		devices = []
		deviceInfo = Variable<DeviceInfo?>(nil)
        discovering = false
		discoveringInfo = Variable<PlayerDiscoveringInfo?>(nil)
        
        discoveryController = DiscoveryController()
		
		disposeBag = DisposeBag()
		
		discoveringStatus = .ready
    }
	
	func startDiscovering() {
        guard let playerServiceID = playerServiceID else {
            return
        }
        
        switch discoveringStatus {
            case .ready:
                discoveryController.searchPlayer(withId: playerServiceID, andListener: self)
                discoveringStatus = .started
            case .stopped:
                discoveringStatus = .started
                discoveryController.resume()
                
                let info = PlayerDiscoveringInfo(status: .started)
                discoveringInfo.value = info
            default: ()
        }
	}
	
	func stopDiscovering() {
		if discoveringStatus == .started {
			discoveringStatus = .stopped
			discoveryController.close()
			devices.removeAll()
			
			let info = PlayerDiscoveringInfo(status: .stopped)
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
            
            self.devicesVariable.value = self.devices
        }
    }
    
    func deviceLost(_ device: RemoteMediaPlayer!) {
		if let index = devices.index (where: { $0.name() == device.name() }) {
			devices.remove(at: index)
            
            self.devicesVariable.value = self.devices
		}
		
		let deviceInfo = DeviceInfo(status: .deviceLost, device: device)
		self.deviceInfo.value = deviceInfo
    }
    
    func discoveryFailure() {
		let info = PlayerDiscoveringInfo(status: .failed)
		discoveringInfo.value = info
    }
}
