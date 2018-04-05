//
//  FireTVSelectionViewController.swift
//  FireTVKit
//
//  Created by crelies on 05.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import UIKit

protocol FireTVSelectionViewProtocol: class {
    func setPresenter(_ presenter: FireTVSelectionPresenterProtocol)
}

class FireTVSelectionViewController: UIViewController, FireTVSelectionViewProtocol {
    private var presenter: FireTVSelectionPresenterProtocol?
	
	@IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FireTVSelectionCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		presenter?.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
		presenter?.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		presenter?.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
		presenter?.viewWillDisappear(animated)
    }
    
    func setPresenter(_ presenter: FireTVSelectionPresenterProtocol) {
        self.presenter = presenter
    }
}

