//
//  PlayerDiscoveringInfo.swift
//  FireTVKit
//
//  Created by crelies on 28.03.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

internal struct PlayerDiscoveringInfo {
    let status: PlayerDiscoveringInfoStatus
    let resetPlayer: Bool
    
    init(status: PlayerDiscoveringInfoStatus) {
        self.status = status
        resetPlayer = false
    }
    
    init(status: PlayerDiscoveringInfoStatus, resetPlayer: Bool) {
        self.status = status
        self.resetPlayer = resetPlayer
    }
}
