//
//  FireTVSelectionPresenter.swift
//  FireTVKit
//
//  Created by crelies on 05.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import RxSwift
import UIKit

final class FireTVSelectionPresenter: NSObject, FireTVSelectionPresenterProtocol {
    private let dependencies: FireTVSelectionPresenterDependenciesProtocol
    private weak var view: FireTVSelectionViewProtocol?
    private let interactor: FireTVSelectionInteractorInputProtocol
    private let router: FireTVSelectionRouterProtocol
    private let theme: FireTVSelectionThemeProtocol
    private weak var delegate: FireTVSelectionDelegateProtocol?
    private let noDevicesText: String
    private let noWifiAlertTitle: String
    private let noWifiAlertMessage: String
	private let disposeBag: DisposeBag
    private var player: [RemoteMediaPlayer]
    private var playerViewModels: [PlayerViewModel]
    private var state: FireTVSelectionPresenterState
    
    init(dependencies: FireTVSelectionPresenterDependenciesProtocol, view: FireTVSelectionViewProtocol, interactor: FireTVSelectionInteractorInputProtocol, router: FireTVSelectionRouterProtocol, theme: FireTVSelectionThemeProtocol, delegate: FireTVSelectionDelegateProtocol, noDevicesText: String, noWifiAlertTitle: String, noWifiAlertMessage: String) {
        self.dependencies = dependencies
        self.view = view
        self.interactor = interactor
        self.router = router
        self.theme = theme
        self.delegate = delegate
        self.noDevicesText = noDevicesText
        self.noWifiAlertTitle = noWifiAlertTitle
        self.noWifiAlertMessage = noWifiAlertMessage
		disposeBag = DisposeBag()
        player = []
        playerViewModels = []
        state = .noDevices
    }
    
    deinit {
        dependencies.logger.log(message: "FireTVSelectionPresenter deinit", event: .info)
    }
    
    func viewDidLoad() {
        view?.setNoDevicesLabelText(noDevicesText)
        view?.setTheme(theme)
        updateUI(withState: .noDevices, animated: false)
        
        if dependencies.reachabilityService.reachability.connection == .wifi {
            interactor.startFireTVDiscovery()
        }
        
        view?.setTableViewDataSource(dataSource: self)
        view?.setTableViewDelegate(delegate: self)
        
        if dependencies.reachabilityService.reachability.connection == .wifi {
            updateUI(withState: .loading, animated: false)
            
            interactor.fireTVs
                .subscribe(onNext: { [weak self] player in
                    self?.dependencies.logger.log(message: "onNext player", event: .info)
                    DispatchQueue.main.async {
                        if !player.isEmpty {
                            self?.updateUI(withState: .devicesFound, animated: true)
                            self?.player = player
                            let playerViewModels = player.map { PlayerViewModel(name: $0.name()) }
                            self?.playerViewModels = playerViewModels
                            self?.view?.reloadData()
                        } else {
                            self?.updateUI(withState: .noDevices, animated: true)
                        }
                    }
                }, onError: { [weak self] error in
                    self?.dependencies.logger.log(message: error.localizedDescription, event: .error)
                    self?.updateUI(withState: .noDevices, animated: true)
                }).disposed(by: disposeBag)
            
            interactor.discoveryFailure
                .subscribe { [weak self] _ in
                    self?.dependencies.logger.log(message: "interactor.discoveryFailure onNext", event: .error)
                    
                    guard let viewController = self?.view as? UIViewController else {
                        return
                    }
                    
                    self?.router.showDiscoveryFailureAlert(fromViewController: viewController, buttonColor: self?.theme.buttonColor ?? .blue) {
                        self?.didPressCloseBarButtonItem()
                    }
                }.disposed(by: disposeBag)
        }
    }
    
    func viewWillAppear() {
        if dependencies.reachabilityService.reachability.connection != .wifi, let viewController = view as? FireTVSelectionViewController {
            router.showNoWifiAlert(fromViewController: viewController, title: noWifiAlertTitle, message: noWifiAlertMessage, buttonColor: theme.buttonColor) { [weak self] in
                self?.updateUI(withState: .loading, animated: true)
                self?.delegate?.didPressCloseButton(viewController)
            }
        }
    }
    
    func didPressCloseBarButtonItem() {
        guard let viewController = view as? FireTVSelectionViewController else {
            return
        }
		
		updateUI(withState: .loading, animated: true)
        
        interactor.stopFireTVDiscovery()
        
        delegate?.didPressCloseButton(viewController)
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
        
        if let fireTVSelectionTableViewCell = cell as? FireTVSelectionTableViewCell {
            fireTVSelectionTableViewCell.updateUI(withTheme: theme)
        }
        
        return cell
    }
}

extension FireTVSelectionPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = view as? FireTVSelectionViewController else {
            return
        }
                
        guard indexPath.row >= 0, indexPath.row < self.player.count else {
            return
        }
        
        let player = self.player[indexPath.row]
        
        let previousState = state
        updateUI(withState: .loading, animated: true)
        if let playMedia = interactor.playMedia(onPlayer: player) {
            playMedia.subscribe(onCompleted: { [weak self] in
                self?.dependencies.logger.log(message: "media played", event: .info)
                self?.updateUI(withState: previousState, animated: true)
            }) { [weak self] error in
                self?.dependencies.logger.log(message: "interactor.playMedia(): \(error.localizedDescription)", event: .error)
                self?.updateUI(withState: previousState, animated: true)
            }.disposed(by: disposeBag)
        }
        delegate?.didSelectPlayer(viewController, player: player)
    }
}

extension FireTVSelectionPresenter {
    private func updateUI(withState state: FireTVSelectionPresenterState, animated: Bool) {
        self.state = state
        switch state {
            case .loading:
				let viewModel = FireTVSelectionViewViewModel(isCloseButtonHidden: true, isTableViewHidden: true, isNoDevicesLabelHidden: true, isActivityIndicatorViewHidden: false)
                view?.updateUI(withViewModel: viewModel, animated: animated)
            
            case .devicesFound:
				let viewModel = FireTVSelectionViewViewModel(isCloseButtonHidden: false, isTableViewHidden: false, isNoDevicesLabelHidden: true, isActivityIndicatorViewHidden: true)
                view?.updateUI(withViewModel: viewModel, animated: animated)
            
            case .noDevices:
				let viewModel = FireTVSelectionViewViewModel(isCloseButtonHidden: false, isTableViewHidden: true, isNoDevicesLabelHidden: false, isActivityIndicatorViewHidden: true)
                view?.updateUI(withViewModel: viewModel, animated: animated)
        }
    }
}
