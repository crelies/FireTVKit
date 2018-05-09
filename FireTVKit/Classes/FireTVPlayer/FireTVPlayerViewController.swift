//
//  FireTVPlayerViewController.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import UIKit

public final class FireTVPlayerViewController: UIViewController {
    private var presenter: FireTVPlayerPresenterProtocol?
    
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var pauseButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
	
	@IBOutlet private weak var positionSlider: UISlider!
	@IBOutlet private weak var positionLabel: UILabel!
	@IBOutlet private weak var durationLabel: UILabel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedTexts()
        presenter?.viewDidLoad()
    }
    
    @IBAction private func didPressCloseButton(_ sender: UIButton) {
        presenter?.didPressCloseButton()
    }
    
    @IBAction private func didPressPlayButton(_ sender: UIButton) {
        presenter?.didPressPlayButton()
    }
    
    @IBAction private func didPressPauseButton(_ sender: UIButton) {
        presenter?.didPressPauseButton()
    }
    
    @IBAction private func didPressStopButton(_ sender: UIButton) {
        presenter?.didPressStopButton()
    }
	
	@IBAction private func didChangePositionValue(_ sender: UISlider) {
		// TODO:
	}
	
	@IBAction private func didChangePosition(_ sender: UISlider) {
		// TODO:
	}
}

extension FireTVPlayerViewController: FireTVPlayerViewProtocol {
    func setPresenter(_ presenter: FireTVPlayerPresenterProtocol) {
        self.presenter = presenter
    }
    
    func setPlayerName(_ playerName: String) {
        nameLabel.text = playerName
    }
    
    func setPositionText(_ positionText: String) {
        positionLabel.text = positionText
    }
	
	func setPosition(_ position: Double) {
		// TODO:
	}
    
    func setDurationText(_ durationText: String) {
        durationLabel.text = durationText
    }
    
    func updateUI(withViewModel viewModel: FireTVPlayerViewControllerViewModel) {
        playButton.isEnabled = viewModel.isPlayerControlEnabled
        pauseButton.isEnabled = viewModel.isPlayerControlEnabled
        stopButton.isEnabled = viewModel.isPlayerControlEnabled
    }
}

extension FireTVPlayerViewController {
    func setLocalizedTexts() {
        // TODO: move to string constants and localizables
        closeButton.setTitle("Close", for: .normal)
        playButton.setTitle("Play", for: .normal)
        pauseButton.setTitle("Pause", for: .normal)
        stopButton.setTitle("Stop", for: .normal)
    }
}
