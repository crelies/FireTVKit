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
    
    // https://www.youtube.com/watch?v=f9psILoYmCc
    private let URL = "https://r1---sn-4g5edne6.googlevideo.com/videoplayback?requiressl=yes&ratebypass=yes&fexp=23724337&fvip=1&ipbits=0&mime=video/mp4&c=WEB&nh=,IgpwZjAxLmFtczE1Kg03NC4xMjUuNTIuMTY1&initcwndbps=1037500&sparams=dur,ei,id,initcwndbps,ip,ipbits,itag,lmt,mime,mm,mn,ms,mv,nh,pl,ratebypass,requiressl,source,expire&source=youtube&pl=17&ei=R-HxWsz0BN3m1gLS7oDQAQ&lmt=1512104683161670&ip=31.17.237.178&expire=1525822887&id=o-AMC0-xbztYAK7BNDM4W1WW-cZNE7-UYneQ5KnwHpUq7y&mn=sn-4g5edne6,sn-5hne6nse&mm=31,26&signature=B413EC6C5286D2ACAD49712215398D0374A1DB9C.E0CA2325FA509264E32BF1BF676F35DD31E7C534&itag=22&mv=m&mt=1525801213&ms=au,onr&key=yt6&dur=178.584"
    
    @IBAction private func didPressPlayerBarButtonItem(_ sender: UIBarButtonItem) {
        do {
            let fireTVSelectionVC = try FireTVSelectionWireframe.makeViewController(playerId: "amzn.thin.pl", delegate: self)
            present(fireTVSelectionVC, animated: true)
        } catch {
            print(error)
        }
    }
    
    @IBAction private func didPressPlayTestVideoButton(_ sender: UIButton) {
        if let selectedDevice = selectedDevice {
            do {
                try PlayerDiscoveryController.shared.startSearch(forPlayerId: nil)
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
            
            var metadata = Metadata(type: "video")
            metadata.title = "Testvideo"
            metadata.description = "A video for test purposes"
            metadata.noreplay = true
            _ = playerService.play(withMetadata: metadata, url: URL)
                .subscribe(onCompleted: {
                    print("success")
                    PlayerDiscoveryController.shared.stopSearch()
                }, onError: { error in
                    print(error)
                    PlayerDiscoveryController.shared.stopSearch()
                })
        }
    }
}

extension ViewController: FireTVSelectionDelegateProtocol {
    func didSelectPlayer(_ fireTVSelectionViewController: FireTVSelectionViewController, player: RemoteMediaPlayer) {
        do {
            selectedDevice = player
            let fireTVPlayerVC = try FireTVPlayerWireframe.makeViewController(forPlayer: player, delegate: self)
            present(fireTVPlayerVC, animated: true)
        } catch {
            print(error)
        }
    }
}

extension ViewController: FireTVPlayerPresenterDelegateProtocol {
    func didPressCloseButton(viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
