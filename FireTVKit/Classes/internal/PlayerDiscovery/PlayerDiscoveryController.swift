//
//  PlayerDiscoveryController.swift
//  FireTVKit
//
//  Created by crelies on 04.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

protocol PlayerDiscoveryControllerProtocol {
	var delegate: PlayerDiscoveryControllerDelegateProtocol? { get set }
	func startSearch(forPlayerId playerId: String?) throws
	func stopSearch()
}

final class PlayerDiscoveryController {
	static let shared = PlayerDiscoveryController()
	
	weak var delegate: PlayerDiscoveryControllerDelegateProtocol?

	private let discoveryController: DiscoveryController
	private var discoveringStatus: DiscoveringStatus
	
	private init() {
		discoveryController = DiscoveryController()
		discoveringStatus = .ready
	}
}

extension PlayerDiscoveryController: PlayerDiscoveryControllerProtocol {
	func startSearch(forPlayerId playerId: String?) throws {
		switch discoveringStatus {
			case .ready:
				weak var playerDiscoveryController = self
				
				if let searchPlayerId = playerId {
					discoveryController.searchPlayer(withId: searchPlayerId, andListener: playerDiscoveryController)
				} else {
					discoveryController.searchDefaultPlayer(with: playerDiscoveryController)
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
		DispatchQueue.main.async { [weak self] in
			guard let weakSelf = self else {
				return
			}
			
			weakSelf.delegate?.deviceDiscovered(weakSelf, device: device)
		}
	}
	
	func deviceLost(_ device: RemoteMediaPlayer!) {
		DispatchQueue.main.async { [weak self] in
			guard let weakSelf = self else {
				return
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
