//
//  PlayerDiscoveryControllerProtocol.swift
//  FireTVKit
//
//  Created by crelies on 06.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

protocol PlayerDiscoveryControllerProtocol {
    var devices: [RemoteMediaPlayer] { get }
    var delegate: PlayerDiscoveryControllerDelegateProtocol? { get set }
    func startSearch(forPlayerId playerId: String?) throws
    func stopSearch()
}
