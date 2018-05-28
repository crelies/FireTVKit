//
//  UIAlertController+MakeAlert.swift
//  FireTVKit
//
//  Created by crelies on 28.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

extension UIAlertController {
	static func makeErrorAlert(title: String, message: String, buttonColor: UIColor, _ handler: @escaping () -> Void) -> UIAlertController {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		let okAction = UIAlertAction(title: StringConstants.Labels.ok, style: .default) { _ in
			handler()
		}
		alertController.addAction(okAction)
		
		alertController.view.tintColor = buttonColor
		
		return alertController
	}
}
