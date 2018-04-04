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
    
    private let URL = "https://r1---sn-4g5e6nl6.googlevideo.com/videoplayback?sparams=dur,ei,id,initcwndbps,ip,ipbits,itag,lmt,mime,mm,mn,ms,mv,pl,ratebypass,requiressl,source,expire&source=youtube&mn=sn-4g5e6nl6,sn-4g5edne6&signature=522E2E7F17A3CC8ED7A5E4FDBD2D186F3454A858.8F7DA07947842E7F0D5338CAD1C3885A51C9F0CD&id=o-AEjMvYuBMyBV81eG8kj3LCfKWBIu_tEPhTjStuOc3Xyb&mime=video/mp4&fvip=1&c=WEB&ip=31.17.237.178&requiressl=yes&ratebypass=yes&mm=31,29&expire=1522800986&ipbits=0&initcwndbps=1243750&dur=178.584&lmt=1512104683161670&key=yt6&ei=-sTDWqmAJoGOgQfC-a3AAw&ms=au,rdu&mt=1522779288&itag=22&mv=m&pl=17"
    
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
            
            _ = playerService.playerData.subscribe(onNext: { playerData in
                if let playerData = playerData {
                    print(playerData)
                }
            })
			
			var metadata = Metadata(type: "video")
			metadata.title = "Testvideo"
			metadata.description = "A video for test purposes"
			metadata.noreplay = true
            _ = playerService.play(withMetadata: metadata, url: URL).subscribe(onCompleted: {
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
