//
//  FireTVSelectionWireframe.swift
//  FireTVKit
//
//  Created by crelies on 05.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import UIKit

extension FireTVSelectionWireframeProtocol {
    public static func makeViewController(theme: FireTVSelectionThemeProtocol, playerId: String, media: FireTVMedia?, delegate: FireTVSelectionDelegateProtocol) throws -> UINavigationController {
        return try makeViewController(theme: theme, playerId: playerId, media: media, delegate: delegate, noDevicesText: StringConstants.FireTVSelection.noDevices, noWifiAlertTitle: StringConstants.Alert.Title.error, noWifiAlertMessage: StringConstants.Alert.Message.noWifi)
    }
    
    public static func configureView(_ view: FireTVSelectionViewProtocol, theme: FireTVSelectionThemeProtocol, playerId: String, media: FireTVMedia?, delegate: FireTVSelectionDelegateProtocol) throws {
        try configureView(view, theme: theme, playerId: playerId, media: media, delegate: delegate, noDevicesText: StringConstants.FireTVSelection.noDevices, noWifiAlertTitle: StringConstants.Alert.Title.error, noWifiAlertMessage: StringConstants.Alert.Message.noWifi)
    }
}

public struct FireTVSelectionWireframe: FireTVSelectionWireframeProtocol {    
    public static func makeViewController(theme: FireTVSelectionThemeProtocol, playerId: String, media: FireTVMedia?, delegate: FireTVSelectionDelegateProtocol, noDevicesText: String, noWifiAlertTitle: String, noWifiAlertMessage: String) throws -> UINavigationController {
        let podBundle = Bundle(for: FireTVSelectionViewController.self)
        
        guard let bundleURL = podBundle.url(forResource: IdentifierConstants.Bundle.resource, withExtension: IdentifierConstants.Bundle.extensionName), let bundle = Bundle(url: bundleURL) else {
            throw FireTVSelectionWireframeError.couldNotFindResourceBundle
        }
        
        guard let navigationController = UIStoryboard(name: IdentifierConstants.Storyboard.fireTVSelection, bundle: bundle).instantiateInitialViewController() as? UINavigationController else {
            throw FireTVSelectionWireframeError.couldNotInstantiateInitialViewController
        }
        
        guard let view = navigationController.viewControllers.first as? FireTVSelectionViewController else {
            throw FireTVSelectionWireframeError.noViewControllersInNavigationController
        }
        let viewControllerDependencies = FireTVSelectionViewControllerDependencies()
        view.dependencies = viewControllerDependencies

        let router = FireTVSelectionRouter()
		
		let interactorDependencies = FireTVSelectionInteractorDependencies()
        let interactor = FireTVSelectionInteractor(dependencies: interactorDependencies, playerId: playerId, media: media)
		
		let presenterDependencies = try FireTVSelectionPresenterDependencies()
        let presenter = FireTVSelectionPresenter(dependencies: presenterDependencies, view: view, interactor: interactor, router: router, theme: theme, delegate: delegate, noDevicesText: noDevicesText, noWifiAlertTitle: noWifiAlertTitle, noWifiAlertMessage: noWifiAlertMessage)
		
		interactor.setPresenter(presenter)
        view.setPresenter(presenter)
        
        return navigationController
    }
    
    public static func configureView(_ view: FireTVSelectionViewProtocol, theme: FireTVSelectionThemeProtocol, playerId: String, media: FireTVMedia?, delegate: FireTVSelectionDelegateProtocol, noDevicesText: String, noWifiAlertTitle: String, noWifiAlertMessage: String) throws {
        let router = FireTVSelectionRouter()
        
        let interactorDependencies = FireTVSelectionInteractorDependencies()
        let interactor = FireTVSelectionInteractor(dependencies: interactorDependencies, playerId: playerId, media: media)
        
        let presenterDependencies = try FireTVSelectionPresenterDependencies()
        let presenter = FireTVSelectionPresenter(dependencies: presenterDependencies, view: view, interactor: interactor, router: router, theme: theme, delegate: delegate, noDevicesText: noDevicesText, noWifiAlertTitle: noWifiAlertTitle, noWifiAlertMessage: noWifiAlertMessage)
        
        interactor.setPresenter(presenter)
        view.setPresenter(presenter)
    }
}
