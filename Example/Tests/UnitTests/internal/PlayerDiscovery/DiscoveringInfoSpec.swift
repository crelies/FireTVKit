//
//  DiscoveringInfoSpec.swift
//  FireTVKit-Tests
//
//  Created by crelies on 28.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

@testable import FireTVKit
import Foundation
import Nimble
import Quick

final class DiscoveringInfoSpec: QuickSpec {
    override func spec() {
        describe("DiscoveringInfo") {
            context("when initialized with device") {
                let player = DummyPlayer()
                let discoveringInfo = DiscoveringInfo(device: player)
                
                it("should have status deviceDiscovered") {
                    expect(discoveringInfo.status) == .deviceDiscovered
                }
            }
        }
    }
}
