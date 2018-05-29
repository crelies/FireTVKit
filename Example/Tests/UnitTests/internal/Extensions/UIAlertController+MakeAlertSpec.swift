//
//  UIAlertController+MakeAlertSpec.swift
//  FireTVKit-Tests
//
//  Created by crelies on 28.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

@testable import FireTVKit
import Foundation
import Nimble
import Quick

final class UIAlertControllerMakeAlertSpec: QuickSpec {
    override func spec() {
        describe("UIAlertController+MakeAlert") {
            context("when making alert") {
                let title = "Test"
                let message = "This is a test message"
                let tintColor: UIColor = .red
                let confirmHandler = {
                    print("confirmed")
                }
                let alertController = UIAlertController.makeErrorAlert(title: title, message: message, buttonColor: tintColor, confirmHandler)
                
                it("should have the correct preferred style") {
                    expect(alertController.preferredStyle) == .alert
                }
                
                it("should have the correct title") {
                    expect(alertController.title) == title
                }
                
                it("should have the correct message") {
                    expect(alertController.message) == message
                }
                
                it("should have the correct tint color") {
                    expect(alertController.view.tintColor) == tintColor
                }
                
                it("should have a confirm action") {
                    guard let confirmAction = alertController.actions.first else {
                        fail("Alert has no actions")
                        return
                    }
                    
                    expect(confirmAction.title) == StringConstants.Labels.ok
                    expect(confirmAction.style) == .default
                }
            }
        }
    }
}
