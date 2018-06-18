//
//  FireTVSelectionPresenterProtocol.swift
//  FireTVKit
//
//  Created by crelies on 22.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Protocol describing the requirements of a `FireTVSelectionPresenter`
/// The presenter in the `VIPER` architecture is responsible for a view
/// and the counterpart of the view
/// Comes to play if you implement a custom `FireTVSelectionViewProtocol`
///
public protocol FireTVSelectionPresenterProtocol: class {
    /// Should be called by a custom `FireTVSelectionViewProtocol` if
    /// your custom view did load
    ///
    func viewDidLoad()
    /// Should be called by a custom `FireTVSelectionViewProtocol` if
    /// your custom view will appear
    ///
    func viewWillAppear()
    /// Should be called by your custom `FireTVSelectionViewProtocol`
    /// if you have a close button which was pressed
    /// The presenter will clean up to be ready to close the view
    ///
    func didPressCloseBarButtonItem()
}
