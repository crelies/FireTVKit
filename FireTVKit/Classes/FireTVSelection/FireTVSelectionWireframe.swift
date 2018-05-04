//
//  FireTVSelectionWireframe.swift
//  FireTVKit
//
//  Created by crelies on 05.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import UIKit

protocol FireTVSelectionWireframeProtocol {
    static func makeViewController() throws -> UINavigationController
}

public struct FireTVSelectionWireframe: FireTVSelectionWireframeProtocol {
	// TODO: pass stream url
    public static func makeViewController() throws -> UINavigationController {
        let podBundle = Bundle(for: FireTVSelectionViewController.self)
        
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
        let interactor = FireTVSelectionInteractor(dependencies: interactorDependencies)
		
		let presenterDependencies = FireTVSelectionPresenterDependencies()
        let presenter = FireTVSelectionPresenter(dependencies: presenterDependencies, view: view, interactor: interactor, router: router)
		
		interactor.setPresenter(presenter)
        view.setPresenter(presenter)
        
        return navigationController
    }
}
