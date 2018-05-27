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

public struct FireTVPlayerWireframe: FireTVPlayerWireframeProtocol {
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
