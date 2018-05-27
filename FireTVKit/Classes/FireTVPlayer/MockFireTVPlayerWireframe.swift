//
//  MockFireTVPlayerWireframe.swift
//  FireTVKit
//
//  Created by crelies on 17.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

public struct MockFireTVPlayerWireframe: FireTVPlayerWireframeProtocol {
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
    
    public static func configureView(_ view: FireTVPlayerViewProtocol, withPlayer player: RemoteMediaPlayer, theme: FireTVPlayerThemeProtocol, delegate: FireTVPlayerDelegateProtocol?, noWifiAlertTitle: String, noWifiAlertMessage: String) {
        
    }
}
