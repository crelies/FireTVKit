//
//  FireTVSelectionWireframe.swift
//  FireTVKit
//
//  Created by crelies on 05.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import UIKit

public struct FireTVSelectionWireframe: FireTVSelectionWireframeProtocol {
	// TODO: pass stream url
    public static func makeViewController() throws -> UINavigationController {
		let podBundle = Bundle(for: FireTVSelectionViewController.self)
		guard let bundleUrl = podBundle.url(forResource: "FireTVKit", withExtension: "bundle"), let bundle = Bundle(url: bundleUrl) else {
			throw FireTVSelectionWireframeError.couldNotFindBundle
		}
		
		guard let navigationController = UIStoryboard(name: "FireTVSelection", bundle: bundle).instantiateInitialViewController() as? UINavigationController else {
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
