//
//  FireTVSelectionViewController.swift
//  FireTVKit
//
//  Created by crelies on 05.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import UIKit

public final class FireTVSelectionViewController: UIViewController {
    private var presenter: FireTVSelectionPresenterProtocol?
	
	@IBOutlet private var tableView: UITableView!
	
	// TODO: remove me
	deinit {
		print("FireTVSelectionViewController deinit")
	}
    
	override public func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FireTVSelectionCell")
    }
    
	override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		presenter?.viewDidAppear(animated)
    }
    
	override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
		presenter?.viewDidDisappear(animated)
    }
    
	override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		presenter?.viewWillAppear(animated)
    }
    
	override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
		presenter?.viewWillDisappear(animated)
    }
	
	@IBAction private func didPressCloseBarButtonItem(sender: UIBarButtonItem) {
		// TODO: move to router
		dismiss(animated: true, completion: nil)
	}
}

extension FireTVSelectionViewController: FireTVSelectionViewProtocol {
	func setPresenter(_ presenter: FireTVSelectionPresenterProtocol) {
		self.presenter = presenter
	}
}
