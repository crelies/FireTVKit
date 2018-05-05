//
//  FireTVPlayerWireframeProtocol.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

protocol FireTVPlayerWireframeProtocol {
    static func makeViewController(forPlayer player: RemoteMediaPlayer) throws -> FireTVPlayerViewController
}
