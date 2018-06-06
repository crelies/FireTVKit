//
//  ViewController.swift
//  FireTVKit-Example
//
//  Created by crelies on 06.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import FireTVKit
import RxSwift
import UIKit

final class ViewController: UIViewController {
    private let disposeBag: DisposeBag = DisposeBag()
    private var selectedDevice: RemoteMediaPlayer?
	private var presentPlayerModally: Bool = false
	
	@IBOutlet private weak var playerContainerView: UIView!
    
    // sample video
	private lazy var SAMPLE_VIDEO_METADATA: Metadata = {
		var metadata = Metadata(type: .video)
		metadata.title = "Testvideo"
		metadata.description = "A video for test purposes"
		metadata.noreplay = true
		return metadata
	}()
    private let SAMPLE_VIDEO_URL = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
	private lazy var SAMPLE_VIDEO: URL? = {
		guard let url = URL(string: SAMPLE_VIDEO_URL) else {
			return nil
		}
		
		return url
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        UserDefaults.standard.setValue(true, forKey: "FireTVKitLogging")
        UserDefaults.standard.setValue(LogEvent.error.rawValue, forKey: "FireTVKitLogEvent")
		
		hidePlayerContainerView()
	}
    
    @IBAction private func didPressPlayerSelectionBarButtonItem(_ sender: UIBarButtonItem) {
        do {
			guard let url = SAMPLE_VIDEO else {
				return
			}
			let media = FireTVMedia(metadata: SAMPLE_VIDEO_METADATA, url: url)
			let selectionTheme = FireTVSelectionDarkTheme()
			let fireTVSelectionVC = try FireTVSelectionWireframe.makeViewController(theme: selectionTheme, playerId: "amzn.thin.pl", media: media, delegate: self)
            present(fireTVSelectionVC, animated: true)
        } catch {
            print(error)
        }
    }
    
    @IBAction private func didPressOpenPlayerButton(_ sender: UIButton) {
        do {
            if let selectedDevice = selectedDevice {
                let theme = FireTVPlayerDarkTheme()
                let fireTVPlayerVC = try FireTVPlayerWireframe.makeViewController(forPlayer: selectedDevice, theme: theme, delegate: self)
                showPlayerViewController(fireTVPlayerVC)
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction private func didPressFireTVManagerExampleViewController(_ sender: UIButton) {
        let fireTVManagerExampleViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FireTVManagerExampleViewController")
        present(fireTVManagerExampleViewController, animated: true, completion: nil)
    }
    
    @IBAction private func didPressDummyPlayerSelectionButtonDarkTheme(_ sender: UIButton) {
        do {
            let selectionTheme = FireTVSelectionDarkTheme()
            let fireTVSelectionVC = try MockFireTVSelectionWireframe.makeViewController(theme: selectionTheme, playerId: "amzn.thin.pl", media: nil, delegate: self)
            fireTVSelectionVC.modalPresentationStyle = .popover
            
            present(fireTVSelectionVC, animated: true)
            
            let popoverPresentationController = fireTVSelectionVC.popoverPresentationController
            popoverPresentationController?.permittedArrowDirections = [.up]
            popoverPresentationController?.sourceRect = sender.frame
            popoverPresentationController?.sourceView = sender
        } catch {
            print(error)
        }
    }
    
    @IBAction private func didPressDummyPlayerSelectionButtonLightTheme(_ sender: UIButton) {
        do {
            let selectionTheme = FireTVSelectionLightTheme()
            let fireTVSelectionVC = try MockFireTVSelectionWireframe.makeViewController(theme: selectionTheme, playerId: "amzn.thin.pl", media: nil, delegate: self)
            fireTVSelectionVC.modalPresentationStyle = .popover
            
            present(fireTVSelectionVC, animated: true)
            
            let popoverPresentationController = fireTVSelectionVC.popoverPresentationController
            popoverPresentationController?.permittedArrowDirections = [.up]
            popoverPresentationController?.sourceRect = sender.frame
            popoverPresentationController?.sourceView = sender
        } catch {
            print(error)
        }
    }
	
	@IBAction private func didPressDummyPlayerButtonDarkTheme(_ sender: UIButton) {
		do {
			let dummyPlayer = DummyPlayer()
			let playerTheme = FireTVPlayerDarkTheme()
			let fireTVPlayerVC = try MockFireTVPlayerWireframe.makeViewController(forPlayer: dummyPlayer, theme: playerTheme, delegate: self)
			showPlayerViewController(fireTVPlayerVC)
		} catch {
			print(error)
		}
	}
    
    @IBAction private func didPressDummyPlayerButtonLightTheme(_ sender: UIButton) {
        do {
            let dummyPlayer = DummyPlayer()
			let playerTheme = FireTVPlayerLightTheme()
			let fireTVPlayerVC = try MockFireTVPlayerWireframe.makeViewController(forPlayer: dummyPlayer, theme: playerTheme, delegate: self)
            showPlayerViewController(fireTVPlayerVC)
        } catch {
            print(error)
        }
    }
}

extension ViewController: FireTVSelectionDelegateProtocol {
    func didSelectPlayer(_ fireTVSelectionViewController: FireTVSelectionViewController, player: RemoteMediaPlayer) {
        do {
            fireTVSelectionViewController.dismiss(animated: true, completion: nil)
            
            if player.uniqueIdentifier() == "DummyPlayerID" {
                return
            }
            
            selectedDevice = player
			let playerTheme = FireTVPlayerDarkTheme()
			let fireTVPlayerVC = try FireTVPlayerWireframe.makeViewController(forPlayer: player, theme: playerTheme, delegate: self)
            showPlayerViewController(fireTVPlayerVC)
        } catch {
            print(error)
        }
    }
    
    func didPressCloseButton(_ fireTVSelectionViewController: FireTVSelectionViewController) {
        fireTVSelectionViewController.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: FireTVPlayerDelegateProtocol {
    func didPressCloseButton(_ fireTVPlayerViewController: FireTVPlayerViewController) {
		hidePlayerViewController(fireTVPlayerViewController)
    }
}

extension ViewController {
	private func showPlayerViewController(_ viewController: FireTVPlayerViewController) {
		if presentPlayerModally {
			present(viewController, animated: true)
		} else {
			addChildViewController(viewController)
			playerContainerView.addSubview(viewController.view)
			
			showPlayerContainerView()
		}
	}
	
	private func hidePlayerViewController(_ viewController: FireTVPlayerViewController) {
		if presentPlayerModally {
			viewController.dismiss(animated: true, completion: nil)
			presentPlayerModally = false
		} else {
			viewController.removeFromParentViewController()
			viewController.view.removeFromSuperview()
			hidePlayerContainerView()
			presentPlayerModally = true
		}
	}
	
	private func showPlayerContainerView() {
		UIView.animate(withDuration: 0.6) {
			self.playerContainerView.alpha = 1
		}
	}
	
	private func hidePlayerContainerView() {
		playerContainerView.alpha = 0
	}
}
