//
//  DiscoveryWorldViewController.swift
//  FireTVKit-Example
//
//  Created by crelies on 06.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import FireTVKit
import RxSwift
import UIKit

final class DiscoveryWorldViewController: UIViewController {
    private let disposeBag: DisposeBag = DisposeBag()
    private var selectedDevice: RemoteMediaPlayer?
    
    private let URL = "https://r1---sn-4g5e6nl6.googlevideo.com/videoplayback?dur=178.584&itag=22&pl=17&ei=M0XvWoegKMmegAfztJG4AQ&sparams=dur,ei,id,initcwndbps,ip,ipbits,itag,lmt,mime,mm,mn,ms,mv,pl,ratebypass,requiressl,source,expire&mime=video/mp4&key=yt6&fexp=23724337&ipbits=0&expire=1525651859&lmt=1512104683161670&id=o-ABzE9LemUdCOTAYBY9A-HhWwb8xSc0bIMxVxeqny7I44&requiressl=yes&mm=31,29&mn=sn-4g5e6nl6,sn-4g5edne6&initcwndbps=1163750&c=WEB&source=youtube&fvip=1&signature=0957CD6DE338C77BD7014DA43BA874657AABDE86.CAB7B1805F116B3C0909F54A1DF7CD220CB7A1A1&ip=31.17.237.178&ms=au,rdu&mt=1525630133&ratebypass=yes&mv=m"
    
    deinit {
        PlayerDiscoveryController.shared.stopSearch()
    }
    
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
                }, onError: { error in
                    print(error)
                })
        }
    }
}

extension DiscoveryWorldViewController: FireTVSelectionDelegateProtocol {
    func didSelectPlayer(_ fireTVSelectionViewController: FireTVSelectionViewController, player: RemoteMediaPlayer) {
        do {
            selectedDevice = player
            let fireTVPlayerVC = try FireTVPlayerWireframe.makeViewController(forPlayer: player)
            present(fireTVPlayerVC, animated: true)
        } catch {
            print(error)
        }
    }
}
