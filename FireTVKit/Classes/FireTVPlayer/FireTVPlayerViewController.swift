//
//  FireTVPlayerViewController.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import UIKit

/// Concrete implementation of the `FireTVPlayerViewProtocol`
///
public final class FireTVPlayerViewController: UIViewController {
    private var presenter: FireTVPlayerPresenterProtocol?
    
    @IBOutlet private weak var closeButton: UIButton!
    
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet private weak var containerView: UIView!
    
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = .clear
        activityIndicatorView.hidesWhenStopped = false
        positionSlider.isEnabled = false
        closeButton.contentEdgeInsets = UIEdgeInsets(top: MetricConstants.ContentInsets.CloseButton.top, left: MetricConstants.ContentInsets.CloseButton.left, bottom: MetricConstants.ContentInsets.CloseButton.bottom, right: MetricConstants.ContentInsets.CloseButton.right)
        setLocalizedTexts()
        setButtonImages()
        presenter?.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
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
	
	public func updateUI(withViewModel viewModel: FireTVPlayerViewViewModel, animated: Bool) {
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
		
		if animated {
			UIView.animate(withDuration: 0.5) {
                self.closeButton.alpha = viewModel.isCloseButtonHidden ? 0 : 1
                
                self.activityIndicatorView.alpha = isActivityIndicatorViewHidden ? 0 : 1
                
				self.positionStackView.alpha = viewModel.isPositionStackViewHidden ? 0 : 1
				self.controlStackView.alpha = viewModel.isControlStackViewHidden ? 0 : 1
				
				self.playerNameLabel.alpha = viewModel.hideLabels ? 0 : 1
				self.mediaNameLabel.alpha = viewModel.hideLabels ? 0 : 1
                
                self.statusLabel.alpha = viewModel.hideLabels ? 0 : 1
			}
		} else {
            closeButton.alpha = viewModel.isCloseButtonHidden ? 0 : 1
            
            activityIndicatorView.alpha = isActivityIndicatorViewHidden ? 0 : 1
            
            positionStackView.alpha = viewModel.isPositionStackViewHidden ? 0 : 1
			controlStackView.alpha = viewModel.isControlStackViewHidden ? 0 : 1
			
			playerNameLabel.alpha = viewModel.hideLabels ? 0 : 1
			mediaNameLabel.alpha = viewModel.hideLabels ? 0 : 1
            
            statusLabel.alpha = viewModel.hideLabels ? 0 : 1
		}
    }
    
    public func updatePositionSliderUserInteractionEnabled(_ enabled: Bool) {
        positionSlider.isEnabled = enabled
    }
}

extension FireTVPlayerViewController {
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
        if let bundleURL = podBundle.url(forResource: IdentifierConstants.Bundle.resource, withExtension: IdentifierConstants.Bundle.extensionName), let bundle = Bundle(url: bundleURL) {
            rewind10sButton.setImage(UIImage(named: IdentifierConstants.Image.rewind10sDisabled, in: bundle, compatibleWith: nil), for: .disabled)
            rewind10sButton.setImage(UIImage(named: IdentifierConstants.Image.rewind10s, in: bundle, compatibleWith: nil), for: .normal)
            playButton.setImage(UIImage(named: IdentifierConstants.Image.playDisabled, in: bundle, compatibleWith: nil), for: .disabled)
            playButton.setImage(UIImage(named: IdentifierConstants.Image.play, in: bundle, compatibleWith: nil), for: .normal)
            pauseButton.setImage(UIImage(named: IdentifierConstants.Image.pauseDisabled, in: bundle, compatibleWith: nil), for: .disabled)
            pauseButton.setImage(UIImage(named: IdentifierConstants.Image.pause, in: bundle, compatibleWith: nil), for: .normal)
            stopButton.setImage(UIImage(named: IdentifierConstants.Image.stopDisabled, in: bundle, compatibleWith: nil), for: .disabled)
            stopButton.setImage(UIImage(named: IdentifierConstants.Image.stop, in: bundle, compatibleWith: nil), for: .normal)
            fastForward10sButton.setImage(UIImage(named: IdentifierConstants.Image.fastForward10sDisabled, in: bundle, compatibleWith: nil), for: .disabled)
            fastForward10sButton.setImage(UIImage(named: IdentifierConstants.Image.fastForward10s, in: bundle, compatibleWith: nil), for: .normal)
        }
    }
}
