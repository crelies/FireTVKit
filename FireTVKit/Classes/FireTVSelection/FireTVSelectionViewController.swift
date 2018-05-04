//
//  FireTVSelectionViewController.swift
//  FireTVKit
//
//  Created by crelies on 02.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

public final class FireTVSelectionViewController: UIViewController {
    private var presenter: FireTVSelectionPresenterProtocol?
    
    @IBOutlet private(set) weak var tableView: UITableView!
    
    deinit {
        print("FireTVSelectionViewController deinit")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: IdentifierConstants.TableView.Cell.fireTVSelection)
        
        presenter?.viewDidLoad()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear(animated)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear(animated)
    }
    
    @IBAction private func didPressCloseBarButtonItem(_ sender: UIBarButtonItem) {
        presenter?.didPressCloseBarButtonItem()
    }
}

extension FireTVSelectionViewController: FireTVSelectionViewProtocol {
    func setPresenter(_ presenter: FireTVSelectionPresenterProtocol) {
        self.presenter = presenter
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
