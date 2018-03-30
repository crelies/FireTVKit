//
//  ViewController.swift
//  FireTVKit-Example
//
//  Created by crelies on 28.03.2018.
//  Copyright (c) 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import FireTVKit
import RxSwift
import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var foundDevicesLabel: UILabel!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var fireTVManager: FireTVManager?
    private var devices: [RemoteMediaPlayer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fireTVManager = FireTVManager()
        
        fireTVManager?.devices.subscribe(onNext: { devices in
            DispatchQueue.main.async {
                if let devices = devices {
                    self.foundDevicesLabel.text = devices.flatMap { $0.name() }.joined(separator: "\n")
                    
                    self.devices = devices
                } else {
                    self.foundDevicesLabel.text = "No devices found"
                }
            }
        }).disposed(by: disposeBag)
        
        if let reachabilityService = ServiceFactory.makeReachabilityService() {
            do {
                reachabilityService.reachabilityInfo.asObservable()
                    .subscribe(onNext: { reachability in
                        if let reachability = reachability {
                            if reachability.connection == .wifi {
                                self.fireTVManager?.startDiscovery(forPlayerID: "amzn.thin.pl")
                            } else {
                                self.fireTVManager?.stopDiscovery()
                            }
                        }
                    }).disposed(by: disposeBag)
                
                try reachabilityService.startListening()
            } catch {
                
            }
        }
    }
    
    @IBAction func didPressStartDiscoveryButton(_ sender: UIButton) {
        fireTVManager?.startDiscovery(forPlayerID: "amzn.thin.pl")
    }
    
    @IBAction func didPressStopDiscoveryButton(_ sender: UIButton) {
        fireTVManager?.stopDiscovery()
    }
    
    @IBAction func didPressPlayTestVideoButton(_ sender: UIButton) {
        if let firstDevice = devices.first {
            let playerService = ServiceFactory.makePlayerService(withPlayer: firstDevice)
            _ = playerService.play(withMetadata: "Barcelona", url: "https://r3---sn-xjpm-i5he.googlevideo.com/videoplayback?dur=166.556&id=o-AAAdnzEOS3RLurJGTwwgY_WsugGS-qbI3OzLztF4ByFD&pl=17&mime=video/mp4&ms=au,rdu&fvip=2&sparams=dur,ei,id,initcwndbps,ip,ipbits,itag,lmt,mime,mm,mn,ms,mv,pl,ratebypass,requiressl,source,expire&source=youtube&initcwndbps=785000&mv=m&mm=31,29&ip=31.17.237.178&mn=sn-xjpm-i5he,sn-4g5ednsd&expire=1522460888&ipbits=0&mt=1522439193&ratebypass=yes&itag=22&signature=BFDB93C1F01D6B11F9A2682C6637359EEB2E774A.AD850720E6A3BEB675A9524E92F318F50F8B52D6&lmt=1522278256189666&requiressl=yes&ei=eJS-WsiQGIXUgQfghoLADg&key=yt6&c=WEB").subscribe(onCompleted: {
                print("success")
            }, onError: { error in
                print(error)
            })
        }
    }
    
    @IBAction func didPressStopPlaybackButton(_ sender: UIButton) {
        if let firstDevice = devices.first {
            let playerService = ServiceFactory.makePlayerService(withPlayer: firstDevice)
            _ = playerService.stop().subscribe(onCompleted: {
                print("success")
            }, onError: { error in
                print(error)
            })
        }
    }
}
