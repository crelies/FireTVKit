//
//  FireTVSelectionWireframe.swift
//  FireTVKit
//
//  Created by crelies on 05.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import UIKit

extension FireTVSelectionWireframe {
	/// Makes a `FireTVSelectionViewController` using default string values
	/// for the `noDevicesText` ("No devices found"), the `noWifiAlertTitle` ("Error")
	/// and the `noWifiAlertMessage` ("You are not connected to a wifi network. The connection is required.")
	///
	/// - Parameters:
	///   - theme: theme for the view controller
	///   - playerId: player id to be searched for
	///   - media: media to be played on player selection
	///   - delegate: delegate which will be notified about actions
	/// - Returns: a `UINavigationController` with a `FireTVSelectionViewController` as the root view controller
	/// - Throws: an error if something unexpected happens
	///
    public static func makeViewController(theme: FireTVSelectionThemeProtocol, playerId: String, media: FireTVMedia?, delegate: FireTVSelectionDelegateProtocol) throws -> UINavigationController {
        return try makeViewController(theme: theme, playerId: playerId, media: media, delegate: delegate, noDevicesText: StringConstants.FireTVSelection.noDevices, noWifiAlertTitle: StringConstants.Alert.Title.error, noWifiAlertMessage: StringConstants.Alert.Message.noWifi)
    }
    
	/// Configures the given view to be ready to go using default string values
	/// for the `noDevicesText` ("No devices found"), the `noWifiAlertTitle` ("Error")
	/// and the `noWifiAlertMessage` ("You are not connected to a wifi network. The connection is required.")
	///
	/// - Parameters:
	///   - view: view to be configured
	///   - theme: theme for the view
	///   - playerId: player id to be searched for
	///   - media: media to play on selected player
	///   - delegate: delegate which will be notified about actions
	/// - Throws: an error if something weird happens
	///
    public static func configureView(_ view: FireTVSelectionViewProtocol, theme: FireTVSelectionThemeProtocol, playerId: String, media: FireTVMedia?, delegate: FireTVSelectionDelegateProtocol) throws {
        try configureView(view, theme: theme, playerId: playerId, media: media, delegate: delegate, noDevicesText: StringConstants.FireTVSelection.noDevices, noWifiAlertTitle: StringConstants.Alert.Title.error, noWifiAlertMessage: StringConstants.Alert.Message.noWifi)
    }
}

/// Responsible for making a `FireTVSelectionViewController` and configuring an implementation of `FireTVSelectionViewProtocol`
///
public struct FireTVSelectionWireframe: FireTVSelectionWireframeProtocol {
    /// Makes a `FireTVSelectionViewController`
    ///
    /// - Parameters:
    ///   - theme: theme for the view controller
    ///   - playerId: player id to be searched for
    ///   - media: media to be played on player selection
    ///   - delegate: delegate which will be notified about actions
    ///   - noDevicesText: a custom no devices text
    ///   - noWifiAlertTitle: a custom title for the no wifi alert
    ///   - noWifiAlertMessage: a custom message for the no wifi alert
    /// - Returns: a `UINavigationController` with a `FireTVSelectionViewController` as the root view controller
    /// - Throws: an error if something unexpected happens
    ///
    public static func makeViewController(theme: FireTVSelectionThemeProtocol, playerId: String, media: FireTVMedia?, delegate: FireTVSelectionDelegateProtocol, noDevicesText: String, noWifiAlertTitle: String, noWifiAlertMessage: String) throws -> UINavigationController {
        let podBundle = Bundle(for: FireTVSelectionViewController.self)
        
        guard let bundleURL = podBundle.url(forResource: IdentifierConstants.Bundle.resource, withExtension: IdentifierConstants.Bundle.extensionName), let bundle = Bundle(url: bundleURL) else {
            throw FireTVSelectionWireframeError.couldNotFindResourceBundle
        }
        
        guard let navigationController = UIStoryboard(name: IdentifierConstants.Storyboard.fireTVSelection, bundle: bundle).instantiateInitialViewController() as? UINavigationController else {
            throw FireTVSelectionWireframeError.couldNotInstantiateInitialViewController
        }
        
        guard let view = navigationController.viewControllers.first as? FireTVSelectionViewController else {
            throw FireTVSelectionWireframeError.noViewControllersInNavigationController
        }
        let viewControllerDependencies = FireTVSelectionViewControllerDependencies()
        view.dependencies = viewControllerDependencies

        let router = FireTVSelectionRouter()
		
		let interactorDependencies = FireTVSelectionInteractorDependencies()
        let interactor = FireTVSelectionInteractor(dependencies: interactorDependencies, playerId: playerId, media: media)
		
		let presenterDependencies = try FireTVSelectionPresenterDependencies()
        let presenter = FireTVSelectionPresenter(dependencies: presenterDependencies, view: view, interactor: interactor, router: router, theme: theme, delegate: delegate, noDevicesText: noDevicesText, noWifiAlertTitle: noWifiAlertTitle, noWifiAlertMessage: noWifiAlertMessage)
		
		interactor.setPresenter(presenter)
        view.setPresenter(presenter)
        
        return navigationController
    }
    
    /// Configures the given view to be ready to go
    ///
    /// - Parameters:
    ///   - view: view to be configured
    ///   - theme: theme for the view
    ///   - playerId: player id to be searched for
    ///   - media: media to play on selected player
    ///   - delegate: delegate which will be notified about actions
    ///   - noDevicesText: custom text to show if no devices were found
    ///   - noWifiAlertTitle: custom title to show in no wifi alert
    ///   - noWifiAlertMessage: custom message to show in no wifi alert
    /// - Throws: an error if something weird happens
    ///
    public static func configureView(_ view: FireTVSelectionViewProtocol, theme: FireTVSelectionThemeProtocol, playerId: String, media: FireTVMedia?, delegate: FireTVSelectionDelegateProtocol, noDevicesText: String, noWifiAlertTitle: String, noWifiAlertMessage: String) throws {
        let router = FireTVSelectionRouter()
        
        let interactorDependencies = FireTVSelectionInteractorDependencies()
        let interactor = FireTVSelectionInteractor(dependencies: interactorDependencies, playerId: playerId, media: media)
        
        let presenterDependencies = try FireTVSelectionPresenterDependencies()
        let presenter = FireTVSelectionPresenter(dependencies: presenterDependencies, view: view, interactor: interactor, router: router, theme: theme, delegate: delegate, noDevicesText: noDevicesText, noWifiAlertTitle: noWifiAlertTitle, noWifiAlertMessage: noWifiAlertMessage)
        
        interactor.setPresenter(presenter)
        view.setPresenter(presenter)
    }
}
