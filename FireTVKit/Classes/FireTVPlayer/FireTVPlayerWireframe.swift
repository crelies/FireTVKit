//
//  FireTVPlayerWireframe.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import UIKit

public struct FireTVPlayerWireframe: FireTVPlayerWireframeProtocol {
	// TODO: sample video in example project
    public static func makeViewController(forPlayer player: RemoteMediaPlayer, theme: FireTVPlayerThemeProtocol, delegate: FireTVPlayerDelegateProtocol?) throws -> FireTVPlayerViewController {
        let podBundle = Bundle(for: FireTVPlayerViewController.self)
        
        // TODO: move to constants
        guard let bundleURL = podBundle.url(forResource: "FireTVKit", withExtension: "bundle"), let bundle = Bundle(url: bundleURL) else {
            throw FireTVPlayerWireframeError.couldNotFindResourceBundle
        }
        
        guard let view = UIStoryboard(name: IdentifierConstants.Storyboard.fireTVPlayer, bundle: bundle).instantiateInitialViewController() as? FireTVPlayerViewController else {
            throw FireTVSelectionWireframeError.couldNotInstantiateInitialViewController
        }
        
        let router = FireTVPlayerRouter()

        let interactorDependencies = FireTVPlayerInteractorDependencies()
        let presenterDependencies = FireTVPlayerPresenterDependencies()

        let interactor = FireTVPlayerInteractor(dependencies: interactorDependencies, player: player)
		let presenter = FireTVPlayerPresenter(dependencies: presenterDependencies, view: view, interactor: interactor, router: router, theme: theme, delegate: delegate)
        interactor.setPresenter(presenter)
        view.setPresenter(presenter)
        
        return view
    }
    
    public static func configureView(_ view: FireTVPlayerViewProtocol, withPlayer player: RemoteMediaPlayer, theme: FireTVPlayerThemeProtocol, delegate: FireTVPlayerDelegateProtocol?) {
        let router = FireTVPlayerRouter()
        
        let interactorDependencies = FireTVPlayerInteractorDependencies()
        let presenterDependencies = FireTVPlayerPresenterDependencies()
        
        let interactor = FireTVPlayerInteractor(dependencies: interactorDependencies, player: player)
        let presenter = FireTVPlayerPresenter(dependencies: presenterDependencies, view: view, interactor: interactor, router: router, theme: theme, delegate: delegate)
        interactor.setPresenter(presenter)
        view.setPresenter(presenter)
    }
}
