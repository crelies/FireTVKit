//
//  FireTVSelectionViewController.swift
//  FireTVKit
//
//  Created by crelies on 05.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

public final class FireTVSelectionViewController: UIViewController {
    private var presenter: FireTVSelectionPresenterProtocol?
    
    @IBOutlet private weak var closeBarButtonItem: UIBarButtonItem!
    @IBOutlet private(set) weak var tableView: UITableView!
    
    // TODO: remove me
    deinit {
        print("FireTVSelectionViewController deinit")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .clear
        
        tableView.register(FireTVSelectionTableViewCell.self, forCellReuseIdentifier: IdentifierConstants.TableView.Cell.fireTVSelection)
        
        presenter?.viewDidLoad()
    }
    
    @IBAction private func didPressCloseBarButtonItem(_ sender: UIBarButtonItem) {
        presenter?.didPressCloseBarButtonItem()
    }
}

extension FireTVSelectionViewController: FireTVSelectionViewProtocol {
    func setPresenter(_ presenter: FireTVSelectionPresenterProtocol) {
        self.presenter = presenter
    }
    
    func setTheme(_ theme: FireTVSelectionThemeProtocol) {
        navigationController?.navigationBar.barTintColor = theme.navigationBarBarTintColor
        view.backgroundColor = theme.backgroundColor
        closeBarButtonItem.tintColor = theme.closeBarButtonItemTintColor
        tableView.separatorColor = theme.cellSeparatorColor
    }
    
    func setTableViewDataSource(dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }
    
    func setTableViewDelegate(delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}
