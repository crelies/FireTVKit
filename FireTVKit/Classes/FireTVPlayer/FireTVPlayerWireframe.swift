//
//  FireTVPlayerWireframe.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import UIKit

extension FireTVPlayerWireframeProtocol {
    public static func makeViewController(forPlayer player: RemoteMediaPlayer, theme: FireTVPlayerThemeProtocol, delegate: FireTVPlayerDelegateProtocol?) throws -> FireTVPlayerViewController {
        return try makeViewController(forPlayer: player, theme: theme, delegate: delegate, noWifiAlertTitle: StringConstants.Alert.Title.error, noWifiAlertMessage: StringConstants.Alert.Message.noWifi)
    }
    
    public static func configureView(_ view: FireTVPlayerViewProtocol, withPlayer player: RemoteMediaPlayer, theme: FireTVPlayerThemeProtocol, delegate: FireTVPlayerDelegateProtocol?) throws {
        try configureView(view, withPlayer: player, theme: theme, delegate: delegate, noWifiAlertTitle: StringConstants.Alert.Title.error, noWifiAlertMessage: StringConstants.Alert.Message.noWifi)
    }
}

/// Responsible for creating a `FireTVPlayerViewController` and for configuring an implementation of the `FireTVPlayerViewProtocol`
///
public struct FireTVPlayerWireframe: FireTVPlayerWireframeProtocol {
    /// Makes a ready to use `FireTVPlayerViewController`
    ///
    /// - Parameters:
    ///   - player: the player which should be represented
    ///   - theme: the theme for the view controller
    ///   - delegate: the delegate which will be notified about actions
    ///   - noWifiAlertTitle: a custom title for the no wifi alert
    ///   - noWifiAlertMessage: a custom message for the no wifi alert
    /// - Returns: a configured `FireTVPlayerViewController` instance
    /// - Throws: an error if something unexpected happens during the creation process
    ///
    public static func makeViewController(forPlayer player: RemoteMediaPlayer, theme: FireTVPlayerThemeProtocol, delegate: FireTVPlayerDelegateProtocol?, noWifiAlertTitle: String, noWifiAlertMessage: String) throws -> FireTVPlayerViewController {
        let podBundle = Bundle(for: FireTVPlayerViewController.self)
        
        guard let bundleURL = podBundle.url(forResource: IdentifierConstants.Bundle.resource, withExtension: IdentifierConstants.Bundle.extensionName), let bundle = Bundle(url: bundleURL) else {
            throw FireTVPlayerWireframeError.couldNotFindResourceBundle
        }
        
        guard let view = UIStoryboard(name: IdentifierConstants.Storyboard.fireTVPlayer, bundle: bundle).instantiateInitialViewController() as? FireTVPlayerViewController else {
            throw FireTVSelectionWireframeError.couldNotInstantiateInitialViewController
        }
        
        let router = FireTVPlayerRouter()

        let interactorDependencies = FireTVPlayerInteractorDependencies()
        let presenterDependencies = try FireTVPlayerPresenterDependencies()

        let interactor = FireTVPlayerInteractor(dependencies: interactorDependencies, player: player)
        let presenter = FireTVPlayerPresenter(dependencies: presenterDependencies, view: view, interactor: interactor, router: router, theme: theme, delegate: delegate, noWifiAlertTitle: noWifiAlertTitle, noWifiAlertMessage: noWifiAlertMessage)
        interactor.setPresenter(presenter)
        view.setPresenter(presenter)
        
        return view
    }
    
    /// Configures the given view to be ready to go
    ///
    /// - Parameters:
    ///   - view: view which should be configured
    ///   - player: player which is represented by the view
    ///   - theme: theme for the view
    ///   - delegate: delegate which will be notified about actions
    ///   - noWifiAlertTitle: a custom title for the no wifi alert
    ///   - noWifiAlertMessage: a custom message for the no wifi alert
    /// - Throws: an error if something unexpected happens during configuration
    ///
    public static func configureView(_ view: FireTVPlayerViewProtocol, withPlayer player: RemoteMediaPlayer, theme: FireTVPlayerThemeProtocol, delegate: FireTVPlayerDelegateProtocol?, noWifiAlertTitle: String, noWifiAlertMessage: String) throws {
        let router = FireTVPlayerRouter()
        
        let interactorDependencies = FireTVPlayerInteractorDependencies()
        let presenterDependencies = try FireTVPlayerPresenterDependencies()
        
        let interactor = FireTVPlayerInteractor(dependencies: interactorDependencies, player: player)
        let presenter = FireTVPlayerPresenter(dependencies: presenterDependencies, view: view, interactor: interactor, router: router, theme: theme, delegate: delegate, noWifiAlertTitle: noWifiAlertTitle, noWifiAlertMessage: noWifiAlertMessage)
        interactor.setPresenter(presenter)
        view.setPresenter(presenter)
    }
}
