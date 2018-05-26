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
	private lazy var closeBarButtonItem: UIBarButtonItem = {
		let podBundle = Bundle(for: FireTVPlayerViewController.self)
		var icon: UIImage?
		// TODO: move to constants
		if let bundleURL = podBundle.url(forResource: "FireTVKit", withExtension: "bundle"), let bundle = Bundle(url: bundleURL) {
			icon = UIImage(named: "close", in: bundle, compatibleWith: nil)
		}
		let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(didPressCloseBarButtonItem(_:)))
		button.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -8, right: -8)
		return button
	}()
    
    @IBOutlet private weak var noDevicesLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    public var dependencies: FireTVSelectionViewControllerDependenciesProtocol?
    @IBOutlet public private(set) weak var tableView: UITableView!
    
    deinit {
        dependencies?.logger.log(message: "FireTVSelectionViewController deinit", event: .info)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
		
		setLocalizedTexts()
		
        tableView.backgroundColor = .clear
        activityIndicatorView.hidesWhenStopped = false
        
        tableView.register(FireTVSelectionTableViewCell.self, forCellReuseIdentifier: IdentifierConstants.TableView.Cell.fireTVSelection)
        
        presenter?.viewDidLoad()
    }
    
	@objc
	private func didPressCloseBarButtonItem(_ sender: UIBarButtonItem) {
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
		activityIndicatorView.color = theme.activityIndicatorViewColor
        closeBarButtonItem.tintColor = theme.closeBarButtonItemTintColor
        tableView.separatorColor = theme.cellSeparatorColor
		noDevicesLabel.textColor = theme.labelColor
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
    
    public func updateUI(withViewModel viewModel: FireTVSelectionViewViewModel) {
		if viewModel.isCloseButtonHidden {
			navigationItem.rightBarButtonItem = nil
		} else {
			navigationItem.rightBarButtonItem = closeBarButtonItem
		}
		
        tableView.isHidden = viewModel.isTableViewHidden
        noDevicesLabel.isHidden = viewModel.isNoDevicesLabelHidden
        
        let isActivityIndicatorViewHidden = viewModel.isActivityIndicatorViewHidden
        if isActivityIndicatorViewHidden {
            activityIndicatorView.stopAnimating()
        } else {
            activityIndicatorView.startAnimating()
        }
        activityIndicatorView.isHidden = isActivityIndicatorViewHidden
    }
}

extension FireTVSelectionViewController {
	private func setLocalizedTexts() {
		closeBarButtonItem.title = ""
        // TODO: move to localizables and string constants
        noDevicesLabel.text = "No devices found"
	}
}
