//
//  FireTVPlayerPresenterProtocol.swift
//  FireTVKit
//
//  Created by crelies on 22.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

public protocol FireTVPlayerPresenterProtocol: class {
    func viewDidLoad()
    func didPressCloseButton()
    func didPressRewind10sButton()
    func didPressPlayButton()
    func didPressPauseButton()
    func didPressStopButton()
    func didPressFastForward10sButton()
    func didChangePositionValue(_ position: Float)
    func didChangePosition(_ position: Float)
}
