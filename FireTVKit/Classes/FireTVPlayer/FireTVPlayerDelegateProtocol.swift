//
//  FireTVPlayerDelegateProtocol.swift
//  FireTVKit
//
//  Created by crelies on 08.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Protocol describing the delegate methods of a fire tv player
///
public protocol FireTVPlayerDelegateProtocol: class {
    func didPressCloseButton(_ fireTVPlayerViewController: FireTVPlayerViewController)
}
