//
//  FireTVSelectionRouter.swift
//  FireTVKit
//
//  Created by crelies on 05.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

protocol FireTVSelectionRouterProtocol {
    func dismiss(viewController: UIViewController)
}

final class FireTVSelectionRouter: FireTVSelectionRouterProtocol {
    func dismiss(viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
