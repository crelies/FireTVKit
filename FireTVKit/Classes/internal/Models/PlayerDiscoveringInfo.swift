//
//  PlayerDiscoveringInfo.swift
//  FireTVKit
//
//  Created by crelies on 28.03.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

struct PlayerDiscoveringInfo {
    let status: PlayerDiscoveringInfoStatus
    
    init(status: PlayerDiscoveringInfoStatus) {
        self.status = status
    }
}
