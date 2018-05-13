//
//  ServiceFactoryProtocol.swift
//  FireTVKit
//
//  Created by crelies on 30.03.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

protocol ServiceFactoryProtocol {
    static func makePlayerDiscoveryService() -> PlayerDiscoveryServiceProtocol
    static func makePlayerService() -> PlayerServiceProtocol
    static func makePlayerService(withPlayer player: RemoteMediaPlayerProtocol) -> PlayerServiceProtocol
    static func makeReachabilityService() -> ReachabilityServiceProtocol?
    static func makeTimeStringFactory() -> TimeStringFactoryProtocol
}
