//
//  TimeStringFactorySpec.swift
//  FireTVKit-Tests
//
//  Created by crelies on 28.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

@testable import FireTVKit
import Foundation
import Nimble
import Quick

final class TimeStringFactorySpec: QuickSpec {
    override func spec() {
        describe("TimeStringFactory") {
            let timeStringFactory = ServiceFactory.makeTimeStringFactory()
            
            context("when making time string from 360405000") {
                it("should return the correct time string") {
                    let timeString = timeStringFactory.makeTimeString(fromMilliseconds: 360405000)
                    expect(timeString) == "100:06:45"
                }
            }
            
            context("when making time string from 360000000") {
                it("should return the correct time string") {
                    let timeString = timeStringFactory.makeTimeString(fromMilliseconds: 360000000)
                    expect(timeString) == "100:00:00"
                }
            }
            
            context("when making time string from 178934") {
                it("should return the correct time string") {
                    let duration = Float(StubConstants.Player.duration)
                    let timeString = timeStringFactory.makeTimeString(fromMilliseconds: duration)
                    expect(timeString) == "00:02:58"
                }
            }
            
            context("when making time string from 5948") {
                it("should return the correct time string") {
                    let position = Float(StubConstants.Player.position)
                    let timeString = timeStringFactory.makeTimeString(fromMilliseconds: position)
                    expect(timeString) == "00:00:05"
                }
            }
            
            context("when making time string from 0") {
                it("should return the correct time string") {
                    let timeString = timeStringFactory.makeTimeString(fromMilliseconds: 0)
                    expect(timeString) == "00:00:00"
                }
            }
            
            context("when making time string from -5") {
                it("should return the correct time string") {
                    let timeString = timeStringFactory.makeTimeString(fromMilliseconds: -5)
                    expect(timeString) == "00:00:00"
                }
            }
        }
    }
}
