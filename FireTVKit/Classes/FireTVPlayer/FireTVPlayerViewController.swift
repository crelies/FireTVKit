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
    
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet private weak var nameLabel: UILabel!
	
    @IBOutlet private weak var positionStackView: UIStackView!
    @IBOutlet private weak var positionSlider: UISlider!
	@IBOutlet private weak var durationLabel: UILabel!
    
    @IBOutlet private weak var positionLabel: UILabel!
    
    @IBOutlet private weak var controlStackView: UIStackView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var pauseButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedTexts()
        setButtonImages()
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
		presenter?.didChangePositionValue(sender.value)
	}
	
	@IBAction private func didChangePosition(_ sender: UISlider) {
		presenter?.didChangePosition(sender.value)
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
	
	func setPosition(_ position: Float) {
		positionSlider.value = position
	}
    
    func setMaximumPosition(_ maximumPosition: Float) {
        positionSlider.maximumValue = maximumPosition
    }
    
    func setDurationText(_ durationText: String) {
        durationLabel.text = durationText
    }
    
    func updateUI(withViewModel viewModel: FireTVPlayerViewControllerViewModel) {
        playButton.isEnabled = viewModel.isPlayerControlEnabled
        pauseButton.isEnabled = viewModel.isPlayerControlEnabled
        stopButton.isEnabled = viewModel.isPlayerControlEnabled
        positionSlider.isEnabled = viewModel.isPlayerControlEnabled
        
        activityIndicatorView.isHidden = viewModel.isActivityIndicatorViewHidden
        positionStackView.isHidden = viewModel.isPositionStackViewHidden
        controlStackView.isHidden = viewModel.isControlStackViewHidden
    }
}

extension FireTVPlayerViewController {
    func setLocalizedTexts() {
        // TODO: move to string constants and localizables
        closeButton.setTitle("Close", for: .normal)
        
        playButton.setTitle("", for: .normal)
        pauseButton.setTitle("", for: .normal)
        stopButton.setTitle("", for: .normal)
    }
    
    private func setButtonImages() {
        let podBundle = Bundle(for: FireTVPlayerViewController.self)
        if let bundleURL = podBundle.url(forResource: "FireTVKit", withExtension: "bundle"), let bundle = Bundle(url: bundleURL) {
            playButton.setImage(UIImage(named: "ic_play_disabled_dark_48dp", in: bundle, compatibleWith: nil), for: .disabled)
            playButton.setImage(UIImage(named: "ic_play_default_dark_48dp", in: bundle, compatibleWith: nil), for: .normal)
            pauseButton.setImage(UIImage(named: "ic_pause_disabled_dark_48dp", in: bundle, compatibleWith: nil), for: .disabled)
            pauseButton.setImage(UIImage(named: "ic_pause_default_dark_48dp", in: bundle, compatibleWith: nil), for: .normal)
            stopButton.setImage(UIImage(named: "ic_stop_disabled_dark_48dp", in: bundle, compatibleWith: nil), for: .disabled)
            stopButton.setImage(UIImage(named: "ic_stop_default_dark_48dp", in: bundle, compatibleWith: nil), for: .normal)
        }
    }
}
