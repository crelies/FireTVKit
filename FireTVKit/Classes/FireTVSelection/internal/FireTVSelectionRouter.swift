//
//  FireTVSelectionRouter.swift
//  FireTVKit
//
//  Created by crelies on 05.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

protocol FireTVSelectionRouterProtocol {
    func showDiscoveryFailureAlert(fromViewController viewController: UIViewController, buttonColor: UIColor, _ confirmHandler: @escaping () -> Void)
    func showNoWifiAlert(fromViewController viewController: UIViewController, title: String, message: String, buttonColor: UIColor, _ confirmHandler: @escaping () -> Void)
}

final class FireTVSelectionRouter: FireTVSelectionRouterProtocol {
    func showDiscoveryFailureAlert(fromViewController viewController: UIViewController, buttonColor: UIColor, _ confirmHandler: @escaping () -> Void) {
		let title = StringConstants.Alert.Title.error
		let message = StringConstants.Alert.Message.discoveryFailure
		
		let alertController = UIAlertController.makeErrorAlert(title: title, message: message, buttonColor: buttonColor, confirmHandler)
		viewController.present(alertController, animated: true, completion: nil)
    }
    
    func showNoWifiAlert(fromViewController viewController: UIViewController, title: String, message: String, buttonColor: UIColor, _ confirmHandler: @escaping () -> Void) {
		let alertController = UIAlertController.makeErrorAlert(title: title, message: message, buttonColor: buttonColor, confirmHandler)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
