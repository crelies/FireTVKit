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
		var metadata = Metadata(type: "video")
		metadata.title = "Testvideo"
		metadata.description = "A video for test purposes"
		metadata.noreplay = true
		return metadata
	}()
    private let SAMPLE_VIDEO_URL = "https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_30mb.mp4"
	private lazy var SAMPLE_VIDEO: URL? = {
		guard let url = URL(string: SAMPLE_VIDEO_URL) else {
			return nil
		}
		
		return url
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		hidePlayerContainerView()
	}
    
    @IBAction private func didPressPlayerBarButtonItem(_ sender: UIBarButtonItem) {
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
    
    @IBAction private func didPressDummyPlayerSelectionButtonDarkTheme(_ sender: UIButton) {
        do {
            let selectionTheme = FireTVSelectionDarkTheme()
            let fireTVSelectionVC = try MockFireTVSelectionWireframe.makeViewController(theme: selectionTheme, playerId: "amzn.thin.pl", media: nil, delegate: self)
            present(fireTVSelectionVC, animated: true)
        } catch {
            print(error)
        }
    }
    
    @IBAction private func didPressDummyPlayerSelectionButtonLightTheme(_ sender: UIButton) {
        do {
            let selectionTheme = FireTVSelectionLightTheme()
            let fireTVSelectionVC = try MockFireTVSelectionWireframe.makeViewController(theme: selectionTheme, playerId: "amzn.thin.pl", media: nil, delegate: self)
            present(fireTVSelectionVC, animated: true)
        } catch {
            print(error)
        }
    }
    
    @IBAction private func didPressPlayTestVideoButton(_ sender: UIButton) {
        if let selectedDevice = selectedDevice {
			let fireTVManager = FireTVManager()
			do {
				try fireTVManager.startDiscovery(forPlayerID: "amzn.thin.pl")
			} catch {
				// TODO:
			}
            
            let playerService = ServiceFactory.makePlayerService(withPlayer: selectedDevice)
            
            _ = playerService.playerData
                .subscribe(onNext: { playerData in
                    if let playerData = playerData {
                        print(playerData)
                    }
                })
			
            _ = playerService.play(withMetadata: SAMPLE_VIDEO_METADATA, url: SAMPLE_VIDEO_URL)
                .subscribe(onCompleted: {
                    print("success")
                    fireTVManager.stopDiscovery()
                }, onError: { error in
                    print(error)
                    fireTVManager.stopDiscovery()
                })
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
            present(fireTVPlayerVC, animated: true)
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
