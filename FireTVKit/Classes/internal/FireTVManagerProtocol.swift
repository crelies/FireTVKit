//
//  FireTVManagerProtocol.swift
//  FireTVKit
//
//  Created by crelies on 30.03.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation
import RxSwift

internal protocol FireTVManagerProtocol {
    var devices: Observable<[RemoteMediaPlayer]?> { get }
    
    func startDiscovery(forPlayerID playerID: String)
    func stopDiscovery()
}
