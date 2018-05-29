//
//  PlayerStatusSpec.swift
//  FireTVKit-Tests
//
//  Created by crelies on 28.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import FireTVKit
import Foundation
import Nimble
import Quick

final class PlayerStatusSpec: QuickSpec {
    override func spec() {
        describe("PlayerStatus") {
			context("when initializing with media state NoMedia") {
				it("should have correct stringValue") {
					let mediaState = NoMedia
					let playerStatus = PlayerStatus(rawValue: mediaState.rawValue)
					expect(playerStatus?.stringValue) == "noMedia"
				}
			}
			
			context("when initializing with media state PreparingMedia") {
				it("should have correct stringValue") {
					let mediaState = PreparingMedia
					let playerStatus = PlayerStatus(rawValue: mediaState.rawValue)
					expect(playerStatus?.stringValue) == "preparingMedia"
				}
			}
			
			context("when initializing with media state ReadyToPlay") {
				it("should have correct stringValue") {
					let mediaState = ReadyToPlay
					let playerStatus = PlayerStatus(rawValue: mediaState.rawValue)
					expect(playerStatus?.stringValue) == "readyToPlay"
				}
			}
			
			context("when initializing with media state Playing") {
				it("should have correct stringValue") {
					let mediaState = Playing
					let playerStatus = PlayerStatus(rawValue: mediaState.rawValue)
					expect(playerStatus?.stringValue) == "playing"
				}
			}
			
			context("when initializing with media state Paused") {
				it("should have correct stringValue") {
					let mediaState = Paused
					let playerStatus = PlayerStatus(rawValue: mediaState.rawValue)
					expect(playerStatus?.stringValue) == "paused"
				}
			}
			
			context("when initializing with media state Seeking") {
				it("should have correct stringValue") {
					let mediaState = Seeking
					let playerStatus = PlayerStatus(rawValue: mediaState.rawValue)
					expect(playerStatus?.stringValue) == "seeking"
				}
			}
			
			context("when initializing with media state Finished") {
				it("should have correct stringValue") {
					let mediaState = Finished
					let playerStatus = PlayerStatus(rawValue: mediaState.rawValue)
					expect(playerStatus?.stringValue) == "finished"
				}
			}
			
			context("when initializing with media state Error") {
				it("should have correct stringValue") {
					let mediaState: MediaState = Error
					let playerStatus = PlayerStatus(rawValue: mediaState.rawValue)
					expect(playerStatus?.stringValue) == "error"
				}
			}
        }
    }
}
