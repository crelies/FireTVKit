//
//  PlayerDiscoveryController.swift
//  FireTVKit
//
//  Created by crelies on 04.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

final class PlayerDiscoveryController {
	static let shared = PlayerDiscoveryController()
	
    private(set) var devices: [RemoteMediaPlayerProtocol]
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
            
            guard let player = device as? RemoteMediaPlayerProtocol else {
                return
            }
            
            weakSelf.devices.append(player)
			
			weakSelf.delegate?.deviceDiscovered(weakSelf, device: player)
		}
	}
	
    func deviceLost(_ device: RemoteMediaPlayer!) {
        print("deviceLost: \(device.name())")
		DispatchQueue.main.async { [weak self] in
			guard let weakSelf = self else {
				return
			}
            
            guard let player = device as? RemoteMediaPlayerProtocol else {
                return
            }
            
            if let index = weakSelf.devices.index (where: { $0.uniqueIdentifier() == player.uniqueIdentifier() }) {
                weakSelf.devices.remove(at: index)
            }
			
			weakSelf.delegate?.deviceLost(weakSelf, device: player)
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
