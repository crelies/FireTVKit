//
//  FireTVPlayerViewProtocol.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

protocol FireTVPlayerViewProtocol: class {
    func setPresenter(_ presenter: FireTVPlayerPresenterProtocol)
    func setPlayerName(_ playerName: String)
    func setPositionText(_ positionText: String)
	func setPosition(_ position: Float)
    func setMaximumPosition(_ maximumPosition: Float)
    func setDurationText(_ durationText: String)
    func updateUI(withViewModel viewModel: FireTVPlayerViewControllerViewModel)
}
