//
//  DiscoveringInfo.swift
//  FireTVKit
//
//  Created by crelies on 28.03.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

struct DiscoveringInfo {
    let status: DiscoveringInfoStatus
    var device: RemoteMediaPlayer?
    
    init(device: RemoteMediaPlayer) {
        status = .deviceDiscovered
        self.device = device
    }
    
    init(status: DiscoveringInfoStatus) {
        self.status = status
    }
    
    init(status: DiscoveringInfoStatus, device: RemoteMediaPlayer) {
        self.status = status
        self.device = device
    }
}
