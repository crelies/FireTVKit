//
//  FireTVSelectionDelegateProtocol.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright (c) 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

public protocol FireTVSelectionDelegateProtocol: class {
    func didSelectPlayer(_ fireTVSelectionViewController: FireTVSelectionViewController, player: RemoteMediaPlayer)
    func didPressCloseButton(_ fireTVSelectionViewController: FireTVSelectionViewController)
}
