//
//  FireTVSelectionWireframe.swift
//  FireTVKit
//
//  Created by crelies on 05.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import UIKit

public struct FireTVSelectionWireframe: FireTVSelectionWireframeProtocol {
	// TODO: use media and theme
    public static func makeViewController(theme: FireTVSelectionThemeProtocol, playerId: String, media: FireTVMedia?, delegate: FireTVSelectionDelegateProtocol) throws -> UINavigationController {
        let podBundle = Bundle(for: FireTVSelectionViewController.self)
        
        // TODO: move to constants
        guard let bundleURL = podBundle.url(forResource: "FireTVKit", withExtension: "bundle"), let bundle = Bundle(url: bundleURL) else {
            throw FireTVSelectionWireframeError.couldNotFindResourceBundle
        }
        
        guard let navigationController = UIStoryboard(name: IdentifierConstants.Storyboard.fireTVSelection, bundle: bundle).instantiateInitialViewController() as? UINavigationController else {
            throw FireTVSelectionWireframeError.couldNotInstantiateInitialViewController
        }
        
        guard let view = navigationController.viewControllers.first as? FireTVSelectionViewController else {
            throw FireTVSelectionWireframeError.noViewControllersInNavigationController
        }

        let router = FireTVSelectionRouter()
		
		let interactorDependencies = FireTVSelectionInteractorDependencies()
        let interactor = FireTVSelectionInteractor(dependencies: interactorDependencies, playerId: playerId)
		
		let presenterDependencies = FireTVSelectionPresenterDependencies()
        let presenter = FireTVSelectionPresenter(dependencies: presenterDependencies, view: view, interactor: interactor, router: router, delegate: delegate)
		
		interactor.setPresenter(presenter)
        view.setPresenter(presenter)
        
        return navigationController
    }
}
