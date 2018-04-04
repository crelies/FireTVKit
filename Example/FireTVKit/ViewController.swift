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
    
    private let URL = "https://r1---sn-4g5edne6.googlevideo.com/videoplayback?ratebypass=yes&pl=17&mime=video/mp4&ipbits=0&ei=aQ3FWvehIcysgQeA-K2gDA&sparams=dur,ei,id,initcwndbps,ip,ipbits,itag,lmt,mime,mm,mn,ms,mv,pl,ratebypass,requiressl,source,expire&c=WEB&expire=1522885065&requiressl=yes&id=o-AOk9a4tp4uz4F4fmBjYwdVJ047eVyUH4iGpv-0VrQ1Vq&dur=178.584&signature=A02CCE9AAB334830D6B1165A3AEA9A602506E4B2.E01E85A3615BEE41FBD8EB3F1071627BD172D917&mm=31,29&mn=sn-4g5edne6,sn-4g5e6nl6&mt=1522863387&itag=22&initcwndbps=1170000&ip=31.17.237.178&key=yt6&lmt=1512104683161670&fvip=1&ms=au,rdu&source=youtube&mv=m"
    
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
            
            playerService.disconnect()
        }
    }
    
    @IBAction func didPressStopPlaybackButton(_ sender: UIButton) {
        if let firstDevice = devices.first {
            let playerService = ServiceFactory.makePlayerService(withPlayer: firstDevice)
            
            _ = playerService.playerData.subscribe(onNext: { playerData in
                if let playerData = playerData {
                    print(playerData)
                }
            })

            _ = playerService.stop().subscribe(onCompleted: {
                print("success")
            }, onError: { error in
                print(error)
            })
            
            playerService.disconnect()
        }
    }
}
