//
//  FireTVPlayerRouter.swift
//  FireTVKit
//
//  Created by crelies on 05.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

protocol FireTVPlayerRouterProtocol {
    func showNoWifiAlert(fromViewController viewController: UIViewController, title: String, message: String, buttonColor: UIColor, _ confirmHandler: @escaping () -> Void)
}

final class FireTVPlayerRouter: FireTVPlayerRouterProtocol {
    func showNoWifiAlert(fromViewController viewController: UIViewController, title: String, message: String, buttonColor: UIColor, _ confirmHandler: @escaping () -> Void) {
		let alertController = UIAlertController.makeErrorAlert(title: title, message: message, buttonColor: buttonColor, confirmHandler)
		viewController.present(alertController, animated: true, completion: nil)
    }
}
