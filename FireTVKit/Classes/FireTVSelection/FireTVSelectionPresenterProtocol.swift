//
//  FireTVSelectionPresenterProtocol.swift
//  FireTVKit
//
//  Created by crelies on 22.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Protocol describing the requirements of a `FireTVSelectionPresenter`
///
public protocol FireTVSelectionPresenterProtocol: class {
    func viewDidLoad()
    func viewWillAppear()
    func didPressCloseBarButtonItem()
}
