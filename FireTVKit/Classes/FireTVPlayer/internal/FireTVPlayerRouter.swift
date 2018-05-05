//
//  FireTVPlayerRouter.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

protocol FireTVPlayerRouterProtocol {
    func dismiss(viewController: UIViewController)
}

final class FireTVPlayerRouter: FireTVPlayerRouterProtocol {
    func dismiss(viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
