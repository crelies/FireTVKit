//
//  FireTVSelectionWireframe.swift
//  FireTVKit
//
//  Created by crelies on 05.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import UIKit

protocol FireTVSelectionWireframeProtocol {
    static func makeViewController() -> FireTVSelectionViewController
}

struct FireTVSelectionWireframe: FireTVSelectionWireframeProtocol {
	// TODO: pass stream url
    static func makeViewController() -> FireTVSelectionViewController {
        let view = FireTVSelectionViewController()
        let router = FireTVSelectionRouter()
		
		let interactorDependencies = FireTVSelectionInteractorDependencies()
        let interactor = FireTVSelectionInteractor(dependencies: interactorDependencies)
		
		let presenterDependencies = FireTVSelectionPresenterDependencies()
        let presenter = FireTVSelectionPresenter(dependencies: presenterDependencies, view: view, interactor: interactor, router: router)
		
		interactor.setPresenter(presenter)
        view.setPresenter(presenter)
        
        return view
    }
}
