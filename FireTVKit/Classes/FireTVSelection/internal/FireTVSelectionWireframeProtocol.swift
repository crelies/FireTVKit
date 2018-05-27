//
//  FireTVSelectionWireframeProtocol.swift
//  FireTVKit
//
//  Created by crelies on 04.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

protocol FireTVSelectionWireframeProtocol {
    static func makeViewController(theme: FireTVSelectionThemeProtocol, playerId: String, media: FireTVMedia?, delegate: FireTVSelectionDelegateProtocol) throws -> UINavigationController
    static func makeViewController(theme: FireTVSelectionThemeProtocol, playerId: String, media: FireTVMedia?, delegate: FireTVSelectionDelegateProtocol, noDevicesText: String, noWifiAlertTitle: String, noWifiAlertMessage: String) throws -> UINavigationController
    static func configureView(_ view: FireTVSelectionViewProtocol, theme: FireTVSelectionThemeProtocol, playerId: String, media: FireTVMedia?, delegate: FireTVSelectionDelegateProtocol) throws
    static func configureView(_ view: FireTVSelectionViewProtocol, theme: FireTVSelectionThemeProtocol, playerId: String, media: FireTVMedia?, delegate: FireTVSelectionDelegateProtocol, noDevicesText: String, noWifiAlertTitle: String, noWifiAlertMessage: String) throws
}
