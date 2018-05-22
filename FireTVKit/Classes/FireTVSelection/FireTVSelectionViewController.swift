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
    
    @IBOutlet public private(set) weak var tableView: UITableView!
    
    // TODO: remove me
    deinit {
        print("FireTVSelectionViewController deinit")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
		
		setLocalizedTexts()
		
        tableView.backgroundColor = .clear
        
        tableView.register(FireTVSelectionTableViewCell.self, forCellReuseIdentifier: IdentifierConstants.TableView.Cell.fireTVSelection)
        
        presenter?.viewDidLoad()
    }
    
    @IBAction private func didPressCloseBarButtonItem(_ sender: UIBarButtonItem) {
        presenter?.didPressCloseBarButtonItem()
    }
}

extension FireTVSelectionViewController: FireTVSelectionViewProtocol {
    public func setPresenter(_ presenter: FireTVSelectionPresenterProtocol) {
        self.presenter = presenter
    }
    
    public func setTheme(_ theme: FireTVSelectionThemeProtocol) {
        navigationController?.navigationBar.barTintColor = theme.navigationBarBarTintColor
        view.backgroundColor = theme.backgroundColor
        closeBarButtonItem.tintColor = theme.closeBarButtonItemTintColor
        tableView.separatorColor = theme.cellSeparatorColor
    }
    
    public func setTableViewDataSource(dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }
    
    public func setTableViewDelegate(delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }
    
    public func reloadData() {
        tableView.reloadData()
    }
}

extension FireTVSelectionViewController {
	private func setLocalizedTexts() {
		closeBarButtonItem.title = ""
	}
}
