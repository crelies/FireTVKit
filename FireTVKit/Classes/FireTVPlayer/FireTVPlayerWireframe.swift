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
	// TODO: add theme, start and stop search discovery controller
    public static func makeViewController(forPlayer player: RemoteMediaPlayer) throws -> FireTVPlayerViewController {
        let podBundle = Bundle(for: FireTVPlayerViewController.self)
        
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
        let presenter = FireTVPlayerPresenter(dependencies: presenterDependencies, view: view, interactor: interactor, router: router)
        interactor.setPresenter(presenter)
        view.setPresenter(presenter)
        
        return view
    }
}
