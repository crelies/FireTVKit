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
    
    private let URL = "https://r6---sn-xjpm-i5he.googlevideo.com/videoplayback?ms=au,rdu&mv=m&pl=17&mt=1525723524&requiressl=yes&mime=video/mp4&lmt=1512104683161670&signature=C3EDD0750E8A8B32ECBD4796B7D4B0071F4754E8.88E7DD5C0975E1A70CC44208B06118A2A6264408&ratebypass=yes&c=WEB&initcwndbps=856250&dur=178.584&mn=sn-xjpm-i5he,sn-4g5edne6&mm=31,29&id=o-AIjG-tEnnbSpZ_4n4BDjTsUpWheVhI8_cZ85crUh6I8w&ei=_LHwWtXUGs3rgAfg2Y_gDw&fexp=23724337&sparams=dur,ei,id,initcwndbps,ip,ipbits,itag,lmt,mime,mm,mn,ms,mv,pl,ratebypass,requiressl,source,expire&expire=1525745244&itag=22&fvip=1&ipbits=0&ip=31.17.237.178&key=yt6&source=youtube"
    
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
