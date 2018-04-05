//
//  FireTVSelectionPresenter.swift
//  FireTVKit
//
//  Created by crelies on 05.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import RxSwift
import UIKit

protocol FireTVSelectionPresenterProtocol: class, FireTVSelectionInteractorOutputProtocol {
    func viewDidLoad()
    func viewDidAppear(_ animated: Bool)
    func viewDidDisappear(_ animated: Bool)
    func viewWillAppear(_ animated: Bool)
    func viewWillDisappear(_ animated: Bool)
}

// TODO: presenter should be table view delegate
class FireTVSelectionPresenter: FireTVSelectionPresenterProtocol {
    private weak var view: FireTVSelectionViewProtocol?
    private let interactor: FireTVSelectionInteractorInputProtocol
    private let router: FireTVSelectionRouterProtocol
    private let dependencies: FireTVSelectionPresenterDependenciesProtocol
	private let disposeBag: DisposeBag
    
    init(dependencies: FireTVSelectionPresenterDependenciesProtocol, view: FireTVSelectionViewProtocol, interactor: FireTVSelectionInteractorInputProtocol, router: FireTVSelectionRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.dependencies = dependencies
		disposeBag = DisposeBag()
    }
    
    func viewDidLoad() {
		interactor.getFireTVs().subscribe(onNext: { player in
			if let player = player {
				// create player view models
				// pass player view models to table view data source
				// reload table view
			}
		}, onError: { error in
			// TODO:
		}).disposed(by: disposeBag)
    }
    
    func viewDidAppear(_ animated: Bool) {
        
    }
    
    func viewDidDisappear(_ animated: Bool) {
        
    }
    
    func viewWillAppear(_ animated: Bool) {
        interactor.startFireTVDiscovery()
    }
    
    func viewWillDisappear(_ animated: Bool) {
        interactor.stopFireTVDiscovery()
    }
}
