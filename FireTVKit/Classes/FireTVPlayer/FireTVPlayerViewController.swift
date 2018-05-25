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
    
    @IBOutlet private weak var mainStackView: UIStackView!
    
    @IBOutlet private weak var playerNameLabel: UILabel!
    @IBOutlet private weak var mediaNameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
	
    @IBOutlet private weak var positionStackView: UIStackView!
    @IBOutlet private weak var positionSlider: UISlider!
	@IBOutlet private weak var durationLabel: UILabel!
    
    @IBOutlet private weak var positionLabel: UILabel!
    
    @IBOutlet private weak var controlStackView: UIStackView!
    @IBOutlet private weak var rewind10sButton: UIButton!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var pauseButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
    @IBOutlet private weak var fastForward10sButton: UIButton!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.hidesWhenStopped = false
        positionSlider.isEnabled = false
        setConstraints()
        setLocalizedTexts()
        setButtonImages()
        presenter?.viewDidLoad()
    }
	
	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if let superview = view.superview {
			let x = view.frame.origin.x
			let y = view.frame.origin.y
			let width = superview.frame.width
			let height = superview.frame.height
			view.frame = CGRect(x: x, y: y, width: width, height: height)
		}
	}
    
    @IBAction private func didPressCloseButton(_ sender: UIButton) {
        presenter?.didPressCloseButton()
    }
    
    @IBAction private func didPressRewind10sButton(_ sender: UIButton) {
        presenter?.didPressRewind10sButton()
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
    
    @IBAction private func didPressFastForward10sButton(_ sender: UIButton) {
        presenter?.didPressFastForward10sButton()
    }
	
	@IBAction private func didChangePositionValue(_ sender: UISlider) {
		presenter?.didChangePositionValue(sender.value)
	}
	
	@IBAction private func didChangePosition(_ sender: UISlider) {
		presenter?.didChangePosition(sender.value)
	}
}

extension FireTVPlayerViewController: FireTVPlayerViewProtocol {
    public func setPresenter(_ presenter: FireTVPlayerPresenterProtocol) {
        self.presenter = presenter
    }
	
	public func setTheme(_ theme: FireTVPlayerThemeProtocol) {
        activityIndicatorView.color = theme.activityIndicatorViewColor
		view.backgroundColor = theme.backgroundColor
		closeButton.tintColor = theme.closeButtonTintColor
		playerNameLabel.textColor = theme.labelColor
        mediaNameLabel.textColor = theme.labelColor
        statusLabel.textColor = theme.labelColor
		positionLabel.textColor = theme.labelColor
		durationLabel.textColor = theme.labelColor
		positionSlider.tintColor = theme.positionSliderTintColor
        rewind10sButton.tintColor = theme.controlButtonTintColor
        playButton.tintColor = theme.controlButtonTintColor
        pauseButton.tintColor = theme.controlButtonTintColor
        stopButton.tintColor = theme.controlButtonTintColor
        fastForward10sButton.tintColor = theme.controlButtonTintColor
	}
    
    public func setPlayerName(_ playerName: String) {
        playerNameLabel.text = playerName
    }
    
    public func setMediaName(_ mediaName: String) {
        mediaNameLabel.text = mediaName
    }
    
    public func setStatus(_ status: String) {
        statusLabel.text = status
    }
    
    public func setPositionText(_ positionText: String) {
        positionLabel.text = positionText
    }
	
	public func setPosition(_ position: Float) {
		positionSlider.value = position
	}
    
    public func setMaximumPosition(_ maximumPosition: Float) {
        positionSlider.maximumValue = maximumPosition
    }
    
    public func setDurationText(_ durationText: String) {
        durationLabel.text = durationText
    }
    
    public func updateUI(withViewModel viewModel: FireTVPlayerViewViewModel) {
		closeButton.isHidden = viewModel.isCloseButtonHidden
		rewind10sButton.isEnabled = viewModel.isPlayerControlEnabled
        playButton.isEnabled = viewModel.isPlayerControlEnabled
        pauseButton.isEnabled = viewModel.isPlayerControlEnabled
        stopButton.isEnabled = viewModel.isPlayerControlEnabled
        fastForward10sButton.isEnabled = viewModel.isPlayerControlEnabled
        
        let isActivityIndicatorViewHidden = viewModel.isActivityIndicatorViewHidden
        if isActivityIndicatorViewHidden {
            activityIndicatorView.stopAnimating()
        } else {
            activityIndicatorView.startAnimating()
        }
        activityIndicatorView.isHidden = isActivityIndicatorViewHidden
        
        positionStackView.isHidden = viewModel.isPositionStackViewHidden
        controlStackView.isHidden = viewModel.isControlStackViewHidden
		
		playerNameLabel.isHidden = viewModel.hideLabels
		mediaNameLabel.isHidden = viewModel.hideLabels
		statusLabel.isHidden = viewModel.hideLabels
    }
    
    public func updatePositionSliderUserInteractionEnabled(_ enabled: Bool) {
        positionSlider.isEnabled = enabled
    }
}

extension FireTVPlayerViewController {
    private func setConstraints() {
        if #available(iOS 11.0, *) {
            mainStackView.setCustomSpacing(16.0, after: statusLabel)
            mainStackView.setCustomSpacing(16.0, after: positionStackView)
        } else {
            // TODO: fallback on earlier versions
        }
    }
    
    private func setLocalizedTexts() {
        closeButton.setTitle("", for: .normal)
		playerNameLabel.text = ""
        mediaNameLabel.text = ""
		statusLabel.text = ""
		positionLabel.text = ""
		durationLabel.text = ""
        rewind10sButton.setTitle("", for: .normal)
        playButton.setTitle("", for: .normal)
        pauseButton.setTitle("", for: .normal)
        stopButton.setTitle("", for: .normal)
        fastForward10sButton.setTitle("", for: .normal)
    }
    
    private func setButtonImages() {
        let podBundle = Bundle(for: FireTVPlayerViewController.self)
        // TODO: move to constants
        if let bundleURL = podBundle.url(forResource: "FireTVKit", withExtension: "bundle"), let bundle = Bundle(url: bundleURL) {
            rewind10sButton.setImage(UIImage(named: "ic_jump_back_10_disabled_dark_48dp", in: bundle, compatibleWith: nil), for: .disabled)
            rewind10sButton.setImage(UIImage(named: "ic_jump_back_10_default_dark_48dp", in: bundle, compatibleWith: nil), for: .normal)
            playButton.setImage(UIImage(named: "ic_play_disabled_dark_48dp", in: bundle, compatibleWith: nil), for: .disabled)
            playButton.setImage(UIImage(named: "ic_play_default_dark_48dp", in: bundle, compatibleWith: nil), for: .normal)
            pauseButton.setImage(UIImage(named: "ic_pause_disabled_dark_48dp", in: bundle, compatibleWith: nil), for: .disabled)
            pauseButton.setImage(UIImage(named: "ic_pause_default_dark_48dp", in: bundle, compatibleWith: nil), for: .normal)
            stopButton.setImage(UIImage(named: "ic_stop_disabled_dark_48dp", in: bundle, compatibleWith: nil), for: .disabled)
            stopButton.setImage(UIImage(named: "ic_stop_default_dark_48dp", in: bundle, compatibleWith: nil), for: .normal)
            fastForward10sButton.setImage(UIImage(named: "ic_jump_forward_10_disabled_dark_48dp", in: bundle, compatibleWith: nil), for: .disabled)
            fastForward10sButton.setImage(UIImage(named: "ic_jump_forward_10_default_dark_48dp", in: bundle, compatibleWith: nil), for: .normal)
        }
    }
}
