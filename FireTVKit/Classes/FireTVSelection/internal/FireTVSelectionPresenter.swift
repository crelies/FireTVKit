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
    func viewWillAppear(_ animated: Bool)
    func viewDidAppear()
    func viewWillDisappear(_ animated: Bool)
    func didPressCloseBarButtonItem()
}

final class FireTVSelectionPresenter: NSObject, FireTVSelectionPresenterProtocol {
    private weak var view: FireTVSelectionViewProtocol?
    private let interactor: FireTVSelectionInteractorInputProtocol
    private let router: FireTVSelectionRouterProtocol
    private let dependencies: FireTVSelectionPresenterDependenciesProtocol
	private let disposeBag: DisposeBag
    private var playerViewModels: [PlayerViewModel]
    
    init(dependencies: FireTVSelectionPresenterDependenciesProtocol, view: FireTVSelectionViewProtocol, interactor: FireTVSelectionInteractorInputProtocol, router: FireTVSelectionRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.dependencies = dependencies
		disposeBag = DisposeBag()
        playerViewModels = []
    }
    
    func viewDidLoad() {
        view?.setTableViewDataSource(dataSource: self)
        view?.setTableViewDelegate(delegate: self)
        
		interactor.getFireTVs().subscribe(onNext: { [weak self] player in
            print("onNext player")
            DispatchQueue.main.async {
                if let player = player {
                    let playerViewModels = player.map { PlayerViewModel(name: $0.name()) }
                    self?.playerViewModels = playerViewModels
                    self?.view?.reloadData()
                }
            }
        }, onError: { error in
            // TODO:
        }).disposed(by: disposeBag)
    }
	
	// TODO: remove me
	deinit {
		print("FireTVSelectionPresenter deinit")
	}
    
    func viewWillAppear(_ animated: Bool) {
        do {
            try interactor.startFireTVDiscovery()
        } catch {
            // TODO:
        }
    }
    
    func viewDidAppear() {
//        interactor.startFireTVDiscovery()
    }
    
    func viewWillDisappear(_ animated: Bool) {
        interactor.stopFireTVDiscovery()
    }
    
    func didPressCloseBarButtonItem() {
        guard let viewController = view as? UIViewController else {
            return
        }
        
        router.dismiss(viewController: viewController)
    }
}

extension FireTVSelectionPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row >= 0, indexPath.row < playerViewModels.count else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IdentifierConstants.TableView.Cell.fireTVSelection, for: indexPath)
        
        let playerViewModel = playerViewModels[indexPath.row]
        cell.textLabel?.text = playerViewModel.name
        
        return cell
    }
}

extension FireTVSelectionPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO:
    }
}
