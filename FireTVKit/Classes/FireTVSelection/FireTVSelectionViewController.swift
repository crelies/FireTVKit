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
		if let bundleURL = podBundle.url(forResource: IdentifierConstants.Bundle.resource, withExtension: IdentifierConstants.Bundle.extensionName), let bundle = Bundle(url: bundleURL) {
			icon = UIImage(named: IdentifierConstants.Image.close, in: bundle, compatibleWith: nil)
		}
		let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(didPressCloseBarButtonItem(_:)))
		button.imageInsets = UIEdgeInsets(top: MetricConstants.ImageInsets.BarButtonItemImage.top, left: MetricConstants.ImageInsets.BarButtonItemImage.left, bottom: MetricConstants.ImageInsets.BarButtonItemImage.bottom, right: MetricConstants.ImageInsets.BarButtonItemImage.right)
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
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
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
    
    public func setNoDevicesLabelText(_ noDevicesLabelText: String) {
        noDevicesLabel.text = noDevicesLabelText
    }
    
    public func setTheme(_ theme: FireTVSelectionThemeProtocol) {
        navigationController?.navigationBar.barTintColor = theme.navigationBarBarTintColor
        view.backgroundColor = theme.backgroundColor
		activityIndicatorView.color = theme.activityIndicatorViewColor
        closeBarButtonItem.tintColor = theme.buttonColor
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
    
    public func updateUI(withViewModel viewModel: FireTVSelectionViewViewModel, animated: Bool) {
		if viewModel.isCloseButtonHidden {
			navigationItem.rightBarButtonItem = nil
		} else {
			navigationItem.rightBarButtonItem = closeBarButtonItem
		}
        
        let isActivityIndicatorViewHidden = viewModel.isActivityIndicatorViewHidden
        if isActivityIndicatorViewHidden {
            activityIndicatorView.stopAnimating()
        } else {
            activityIndicatorView.startAnimating()
        }
        
        if animated {
            UIView.animate(withDuration: 0.5) {
                self.tableView.alpha = viewModel.isTableViewHidden ? 0 : 1
                self.noDevicesLabel.alpha = viewModel.isNoDevicesLabelHidden ? 0 : 1
                self.activityIndicatorView.alpha = isActivityIndicatorViewHidden ? 0 : 1
            }
        } else {
            tableView.alpha = viewModel.isTableViewHidden ? 0 : 1
            noDevicesLabel.alpha = viewModel.isNoDevicesLabelHidden ? 0 : 1
            activityIndicatorView.alpha = isActivityIndicatorViewHidden ? 0 : 1
        }
    }
}

extension FireTVSelectionViewController {
	private func setLocalizedTexts() {
		closeBarButtonItem.title = ""
	}
}
