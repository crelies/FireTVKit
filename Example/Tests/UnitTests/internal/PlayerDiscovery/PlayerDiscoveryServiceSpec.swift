//
//  PlayerDiscoveryServiceSpec.swift
//  FireTVKit-Tests
//
//  Created by crelies on 28.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
@testable import FireTVKit
import Foundation
import Nimble
import Quick
import RxSwift

final class PlayerDiscoveryServiceSpec: QuickSpec {
    override func spec() {
        describe("PlayerDiscoveryService") {
            let dependencies = MockPlayerDiscoveryServiceDependencies()
            (dependencies.playerDiscoveryController as? MockPlayerDiscoveryController)?.diceRollEnabled = false
            let service = PlayerDiscoveryService(dependencies: dependencies)
            let player = DummyPlayer()
            
            context("when startDiscovering was called") {
                it("should emit devices") {
                    let disposeBag = DisposeBag()
                    var devices: [RemoteMediaPlayer]?
                    
                    service.devicesObservable.subscribe(onNext: { player in
                        devices = player
                    }, onError: { error in
                        fail(error.localizedDescription)
                    }).disposed(by: disposeBag)
                    
                    service.startDiscovering()
                    
                    expect(devices).toEventuallyNot(beNil())
                    // count is 1 because mock player discovery controller devices property always returns one device
                    expect(devices?.count) == 1
                }
            }
            
            context("when stopDiscovering was called") {
                it("should emit empty array") {
                    let disposeBag = DisposeBag()
                    var devices: [RemoteMediaPlayer]?
                    
                    service.devicesObservable.subscribe(onNext: { player in
                        devices = player
                    }, onError: { error in
                        fail(error.localizedDescription)
                    }).disposed(by: disposeBag)
                    
                    service.stopDiscovering()
                    
                    expect(devices).toEventuallyNot(beNil())
                    expect(devices?.count) == 0
                }
            }
            
            context("when delegate method deviceDiscovered was called") {
                it("should emit devices") {
                    let disposeBag = DisposeBag()
                    var devices: [RemoteMediaPlayer]?
                    
                    service.devicesObservable.subscribe(onNext: { player in
                        devices = player
                    }, onError: { error in
                        fail(error.localizedDescription)
                    }).disposed(by: disposeBag)
                    
                    dependencies.playerDiscoveryController.delegate?.deviceDiscovered(dependencies.playerDiscoveryController, device: player)
                    
                    expect(devices).toEventuallyNot(beNil())
                    // count is 1 because mock player discovery controller devices property always returns one device
                    expect(devices?.count) == 1
                }
                
                it("should emit discovering info") {
                    let disposeBag = DisposeBag()
                    var discoveringInfo: DiscoveringInfo?
                    
                    service.discoveringInfoObservable.subscribe(onNext: { info in
                        discoveringInfo = info
                    }, onError: { error in
                        fail(error.localizedDescription)
                    }).disposed(by: disposeBag)
                    
                    dependencies.playerDiscoveryController.delegate?.deviceDiscovered(dependencies.playerDiscoveryController, device: player)
                    
                    expect(discoveringInfo).toEventuallyNot(beNil())
                    expect(discoveringInfo?.status) == .deviceDiscovered
                    expect(discoveringInfo?.device?.uniqueIdentifier()) == player.uniqueIdentifier()
                }
            }
            
            context("when delegate method deviceLost was called") {
                it("should emit devices") {
                    let disposeBag = DisposeBag()
                    var devices: [RemoteMediaPlayer]?
                    
                    service.devicesObservable.subscribe(onNext: { player in
                        devices = player
                    }, onError: { error in
                        fail(error.localizedDescription)
                    }).disposed(by: disposeBag)
                    
                    dependencies.playerDiscoveryController.delegate?.deviceLost(dependencies.playerDiscoveryController, device: player)
                    
                    expect(devices).toEventuallyNot(beNil())
                    // count is 1 because mock player discovery controller devices property always returns one device
                    expect(devices?.count) == 1
                }
                
                it("should emit discovering info") {
                    let disposeBag = DisposeBag()
                    var discoveringInfo: DiscoveringInfo?
                    
                    service.discoveringInfoObservable.subscribe(onNext: { info in
                        discoveringInfo = info
                    }, onError: { error in
                        fail(error.localizedDescription)
                    }).disposed(by: disposeBag)
                    
                    dependencies.playerDiscoveryController.delegate?.deviceLost(dependencies.playerDiscoveryController, device: player)
                    
                    expect(discoveringInfo).toEventuallyNot(beNil())
                    expect(discoveringInfo?.status) == .deviceLost
                    expect(discoveringInfo?.device?.uniqueIdentifier()) == player.uniqueIdentifier()
                }
            }
            
            context("when delegate method discoveryFailure was called") {
                it("should emit discovering info") {
                    let disposeBag = DisposeBag()
                    var discoveringInfo: DiscoveringInfo?
                    
                    service.discoveringInfoObservable.subscribe(onNext: { info in
                        discoveringInfo = info
                    }, onError: { error in
                        fail(error.localizedDescription)
                    }).disposed(by: disposeBag)
                    
                    dependencies.playerDiscoveryController.delegate?.discoveryFailure(dependencies.playerDiscoveryController)
                    
                    expect(discoveringInfo).toEventuallyNot(beNil())
                    expect(discoveringInfo?.status) == .discoveryFailure
                    expect(discoveringInfo?.device).to(beNil())
                }
            }
        }
    }
}
