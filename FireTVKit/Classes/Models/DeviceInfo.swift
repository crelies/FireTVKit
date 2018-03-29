//
//  DeviceInfo.swift
//  FireTVKit
//
//  Created by crelies on 28.03.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

internal struct DeviceInfo {
    let status: DeviceInfoStatus
    var device: RemoteMediaPlayer?
    
    init(device: RemoteMediaPlayer) {
        status = .deviceDiscovered
        self.device = device
    }
    
    init(status: DeviceInfoStatus) {
        self.status = status
    }
    
    init(status: DeviceInfoStatus, device: RemoteMediaPlayer) {
        self.status = status
        self.device = device
    }
}
