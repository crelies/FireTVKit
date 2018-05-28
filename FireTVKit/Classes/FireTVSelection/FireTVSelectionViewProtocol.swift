//
//  FireTVSelectionViewProtocol.swift
//  FireTVKit
//
//  Created by crelies on 05.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import UIKit

public protocol FireTVSelectionViewProtocol: class {
    var dependencies: FireTVSelectionViewControllerDependenciesProtocol? { get set }
    var tableView: UITableView! { get }
    
    func setPresenter(_ presenter: FireTVSelectionPresenterProtocol)
    func setNoDevicesLabelText(_ noDevicesLabelText: String)
    func setTheme(_ theme: FireTVSelectionThemeProtocol)
    func setTableViewDataSource(dataSource: UITableViewDataSource)
    func setTableViewDelegate(delegate: UITableViewDelegate)
    func reloadData()
    func updateUI(withViewModel viewModel: FireTVSelectionViewViewModel)
    func updateUI(withViewModel viewModel: FireTVSelectionViewViewModel, animated: Bool)
}

extension FireTVSelectionViewProtocol {
    public func updateUI(withViewModel viewModel: FireTVSelectionViewViewModel) {
        updateUI(withViewModel: viewModel, animated: false)
    }
}
