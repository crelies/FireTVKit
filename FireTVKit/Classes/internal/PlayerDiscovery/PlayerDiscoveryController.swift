//
//  PlayerDiscoveryController.swift
//  FireTVKit
//
//  Created by crelies on 04.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

protocol PlayerDiscoveryControllerProvider {
	var playerDiscoveryController: PlayerDiscoveryControllerProtocol { get }
}

final class PlayerDiscoveryController {
	static let shared = PlayerDiscoveryController()
	
    private(set) var devices: [RemoteMediaPlayer]
	weak var delegate: PlayerDiscoveryControllerDelegateProtocol?

	private let discoveryController: DiscoveryController
	private var discoveringStatus: DiscoveringStatus
	
	private init() {
        devices = []
		discoveryController = DiscoveryController()
		discoveringStatus = .ready
	}
}

extension PlayerDiscoveryController: PlayerDiscoveryControllerProtocol {
	func startSearch(forPlayerId playerId: String?) {
		switch discoveringStatus {
			case .ready:
				if let searchPlayerId = playerId {
                    discoveryController.searchPlayer(withId: searchPlayerId, andListener: self)
				} else {
					discoveryController.searchDefaultPlayer(with: self)
				}
				discoveringStatus = .started
			
			case .stopped:
				discoveryController.resume()
				discoveringStatus = .started
			
			default: ()
		}
	}
	
	func stopSearch() {
		discoveryController.close()
		discoveringStatus = .stopped
	}
}

extension PlayerDiscoveryController: DiscoveryListener {
    func deviceDiscovered(_ device: RemoteMediaPlayer!) {
        print("deviceDiscovered: \(device.name())")
		DispatchQueue.main.async { [weak self] in
			guard let weakSelf = self else {
				return
			}
            
            weakSelf.devices.append(device)
			
			weakSelf.delegate?.deviceDiscovered(weakSelf, device: device)
		}
	}
	
    func deviceLost(_ device: RemoteMediaPlayer!) {
        print("deviceLost: \(device.name())")
		DispatchQueue.main.async { [weak self] in
			guard let weakSelf = self else {
				return
			}
            
            if let index = weakSelf.devices.index (where: { $0.uniqueIdentifier() == device.uniqueIdentifier() }) {
                weakSelf.devices.remove(at: index)
            }
			
			weakSelf.delegate?.deviceLost(weakSelf, device: device)
		}
	}
	
    func discoveryFailure() {
		DispatchQueue.main.async { [weak self] in
			guard let weakSelf = self else {
				return
			}
			
			weakSelf.delegate?.discoveryFailure(weakSelf)
		}
	}
}
