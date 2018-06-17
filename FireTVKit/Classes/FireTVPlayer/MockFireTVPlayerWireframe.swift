//
//  MockFireTVPlayerWireframe.swift
//  FireTVKit
//
//  Created by crelies on 17.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

/// Mock implementation of `FireTVPlayerWireframeProtocol`
/// Use only for creating a mock player view controller (testing purposes)
///
public struct MockFireTVPlayerWireframe: FireTVPlayerWireframeProtocol {
    public static func makeViewController(forPlayer player: RemoteMediaPlayer, theme: FireTVPlayerThemeProtocol, delegate: FireTVPlayerDelegateProtocol?) throws -> FireTVPlayerViewController {
        return try makeViewController(forPlayer: player, theme: theme, delegate: delegate, noWifiAlertTitle: "No Wifi", noWifiAlertMessage: "No Wifi")
    }
    
    public static func configureView(_ view: FireTVPlayerViewProtocol, withPlayer player: RemoteMediaPlayer, theme: FireTVPlayerThemeProtocol, delegate: FireTVPlayerDelegateProtocol?) throws {
        
    }
    
    /// Creates a mock player view controller
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
		
		let interactorDependencies = MockFireTVPlayerInteractorDependencies()
		let presenterDependencies = try FireTVPlayerPresenterDependencies()
		
		let interactor = FireTVPlayerInteractor(dependencies: interactorDependencies, player: player)
        let presenter = FireTVPlayerPresenter(dependencies: presenterDependencies, view: view, interactor: interactor, router: router, theme: theme, delegate: delegate, noWifiAlertTitle: noWifiAlertTitle, noWifiAlertMessage: noWifiAlertMessage)
		interactor.setPresenter(presenter)
		view.setPresenter(presenter)
		
		return view
	}
    
    /// Mock implementation: does nothing!
    ///
    public static func configureView(_ view: FireTVPlayerViewProtocol, withPlayer player: RemoteMediaPlayer, theme: FireTVPlayerThemeProtocol, delegate: FireTVPlayerDelegateProtocol?, noWifiAlertTitle: String, noWifiAlertMessage: String) {
        
    }
}
