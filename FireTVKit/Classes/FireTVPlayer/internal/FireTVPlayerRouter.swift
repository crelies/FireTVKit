//
//  FireTVPlayerRouter.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

protocol FireTVPlayerRouterProtocol {
    func showNoWifiAlert(fromViewController viewController: UIViewController, _ confirmHandler: @escaping () -> Void)
}

final class FireTVPlayerRouter: FireTVPlayerRouterProtocol {
    func showNoWifiAlert(fromViewController viewController: UIViewController, _ confirmHandler: @escaping () -> Void) {
        // TODO: move to constants
        let title = "Error"
        let message = "No wifi"
        // TODO: move alert controller creation to extension
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // TODO: move to constants
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            confirmHandler()
        }
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
