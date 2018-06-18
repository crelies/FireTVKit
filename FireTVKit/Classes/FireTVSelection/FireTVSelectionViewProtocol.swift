//
//  FireTVSelectionViewProtocol.swift
//  FireTVKit
//
//  Created by crelies on 05.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import UIKit

/// Protocol representing the requirements of a fire tv selection view
/// Methods will be called by an implementation of the `FireTVSelectionPresenterProtocol`
///
public protocol FireTVSelectionViewProtocol: class {
    /// Property for storing the dependencies of the view
    /// Will be set by the methods of the `FireTVSelectionWireframe`
    ///
    var dependencies: FireTVSelectionViewControllerDependenciesProtocol? { get set }
    /// The table view presenting the found fire tvs
    ///
    var tableView: UITableView! { get }
    
    /// Called by the `FireTVSelectionWireframe`
    /// Store the presenter in a property
    /// The presenter is the counterpart of the view in the `VIPER` architecture
    /// He is responsible for updating the view
    ///
    /// - Parameter presenter: presenter for the view
    ///
    func setPresenter(_ presenter: FireTVSelectionPresenterProtocol)
    /// Called by the presenter to pass the text for the no devices label to the view
    ///
    /// - Parameter noDevicesLabelText: text to show in the no devices label
    ///
    func setNoDevicesLabelText(_ noDevicesLabelText: String)
    /// Presenter calls the method to tell the view to use the given theme
    ///
    /// - Parameter theme: theme which should be set
    ///
    func setTheme(_ theme: FireTVSelectionThemeProtocol)
    /// Called by the presenter to pass a data source for the table view of the view
    ///
    /// - Parameter dataSource: table view data source
    ///
    func setTableViewDataSource(dataSource: UITableViewDataSource)
    /// Presenter calls the method to pass a delegate for the table view to the view
    ///
    /// - Parameter delegate: table view delegate
    ///
    func setTableViewDelegate(delegate: UITableViewDelegate)
    /// Called by the presenter to tell the view to reload the data of the table view
    ///
    func reloadData()
    /// Called by the presenter to tell the view to update the ui using the given view model
    /// without an animation
    ///
    /// - Parameter viewModel: view model for the ui update
    ///
    func updateUI(withViewModel viewModel: FireTVSelectionViewViewModel)
    /// Presenter calls the method to tell the view to update the ui
    /// with or without an animation using the given view model
    ///
    /// - Parameters:
    ///   - viewModel: view model for the ui update
    ///   - animated: boolean value indicating if the ui update should be animated or not
    ///
    func updateUI(withViewModel viewModel: FireTVSelectionViewViewModel, animated: Bool)
}

extension FireTVSelectionViewProtocol {
    /// Default implementation updating the ui using
    /// the given view model without an animation
    ///
    /// - Parameter viewModel: view model for the ui update
    ///
    public func updateUI(withViewModel viewModel: FireTVSelectionViewViewModel) {
        updateUI(withViewModel: viewModel, animated: false)
    }
}
