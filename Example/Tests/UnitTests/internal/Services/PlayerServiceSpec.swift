//
//  PlayerServiceSpec.swift
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

final class PlayerServiceSpec: QuickSpec {
    override func spec() {
        describe("PlayerService") {
            let dependencies = MockPlayerServiceDependencies()
            let dummyPlayer = DummyPlayer()
            let service = PlayerService(dependencies: dependencies, withPlayer: dummyPlayer)
            
            beforeEach {
                service.player = dummyPlayer
            }
            
            context("when connecting to player") {
                it("should connect to player") {
                    let disposeBag = DisposeBag()
                    var success: Bool?
                    service.connectToPlayer(dummyPlayer)
                        .subscribe(onCompleted: {
                            success = true
                        }, onError: { error in
                            fail(error.localizedDescription)
                        }).disposed(by: disposeBag)
                    
                    expect(success).toEventuallyNot(beNil())
                    expect(success) == true
                }
            }
            
            context("when playing") {
                it("should play") {
                    let disposeBag = DisposeBag()
                    var success: Bool?
                    service.play()
                        .subscribe(onCompleted: {
                            success = true
                        }, onError: { error in
                            fail(error.localizedDescription)
                        }).disposed(by: disposeBag)
                    
                    expect(success).toEventuallyNot(beNil())
                    expect(success) == true
                }
            }
            
            context("when playing using metadata and url") {
                it("should play") {
                    let disposeBag = DisposeBag()
                    let metadata = Metadata(type: .video)
                    let url = StubConstants.Player.source
                    var success: Bool?
                    service.play(withMetadata: metadata, url: url)
                        .subscribe(onCompleted: {
                            success = true
                        }, onError: { error in
                            fail(error.localizedDescription)
                        }).disposed(by: disposeBag)
                    
                    expect(success).toEventuallyNot(beNil())
                    expect(success) == true
                }
            }
            
            context("when pausing") {
                it("should pause") {
                    let disposeBag = DisposeBag()
                    var success: Bool?
                    service.pause()
                        .subscribe(onCompleted: {
                            success = true
                        }, onError: { error in
                            fail(error.localizedDescription)
                        }).disposed(by: disposeBag)
                    
                    expect(success).toEventuallyNot(beNil())
                    expect(success) == true
                }
            }
            
            context("when setting position with seek type") {
                it("should set position") {
                    let disposeBag = DisposeBag()
                    var success: Bool?
                    let position: Int64 = 1953
                    let seekType: SeekType = ABSOLUTE
                    service.setPosition(position: position, type: seekType)
                        .subscribe(onCompleted: {
                            success = true
                        }, onError: { error in
                            fail(error.localizedDescription)
                        }).disposed(by: disposeBag)
                    
                    expect(success).toEventuallyNot(beNil())
                    expect(success) == true
                }
            }
            
            context("when stopping") {
                it("should stop") {
                    let disposeBag = DisposeBag()
                    var success: Bool?
                    service.stop()
                        .subscribe(onCompleted: {
                            success = true
                        }, onError: { error in
                            fail(error.localizedDescription)
                        }).disposed(by: disposeBag)
                    
                    expect(success).toEventuallyNot(beNil())
                    expect(success) == true
                }
            }
            
            context("when getting player info") {
                it("should return player info") {
                    let disposeBag = DisposeBag()
                    var playerInfo: MediaPlayerInfo?
                    service.getPlayerInfo()
                        .subscribe(onSuccess: { mediaPlayerInfo in
                            playerInfo = mediaPlayerInfo
                        }, onError: { error in
                            fail(error.localizedDescription)
                        }).disposed(by: disposeBag)
                    
                    expect(playerInfo).toEventuallyNot(beNil())
                }
            }
            
            context("when getting player data") {
                it("should return player data") {
                    let disposeBag = DisposeBag()
                    var playerData: PlayerData?
                    service.getPlayerData()
                        .subscribe(onSuccess: { data in
                            playerData = data
                        }, onError: { error in
                            fail(error.localizedDescription)
                        }).disposed(by: disposeBag)
                    
                    expect(playerData).toEventuallyNot(beNil())
                }
            }
            
            context("when getting duration") {
                it("should return duration") {
                    let disposeBag = DisposeBag()
                    var duration: Int64?
                    service.getDuration()
                        .subscribe(onSuccess: { playerDuration in
                            duration = playerDuration
                        }, onError: { error in
                            fail(error.localizedDescription)
                        }).disposed(by: disposeBag)
                    
                    expect(duration).toEventuallyNot(beNil())
                }
            }
            
            context("when getting position") {
                it("should return position") {
                    let disposeBag = DisposeBag()
                    var position: Int64?
                    service.getPosition()
                        .subscribe(onSuccess: { playerPosition in
                            position = playerPosition
                        }, onError: { error in
                            fail(error.localizedDescription)
                        }).disposed(by: disposeBag)
                    
                    expect(position).toEventuallyNot(beNil())
                }
            }
            
            context("when disconnecting from player") {
                it("should disconnect from player") {
                    let disposeBag = DisposeBag()
                    var success: Bool?
                    service.disconnect(fromPlayer: dummyPlayer)
                        .subscribe(onCompleted: {
                            success = true
                        }, onError: { error in
                            fail(error.localizedDescription)
                        }).disposed(by: disposeBag)
                    
                    expect(success).toEventuallyNot(beNil())
                    expect(success) == true
                }
            }
            
            context("when disconnecting from current player which is nil") {
                it("should throw error") {
                    let disposeBag = DisposeBag()
                    var success: Bool?
                    
                    service.player = nil
                    do {
                        try service.disconnectFromCurrentPlayer()
                            .subscribe(onCompleted: {
                                success = true
                            }, onError: { _ in
                                success = false
                            }).disposed(by: disposeBag)
                        
                        expect(success).toEventuallyNot(beNil())
                        fail("No error was thrown")
                    } catch {
                        
                    }
                }
            }
        }
    }
}
