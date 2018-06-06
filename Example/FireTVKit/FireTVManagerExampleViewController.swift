//
//  FireTVManagerExampleViewController.swift
//  FireTVKit-Example
//
//  Created by crelies on 06.06.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import FireTVKit
import RxSwift
import UIKit

final class FireTVManagerExampleViewController: UIViewController {
    private var fireTVManager: FireTVManager?
    private var disposeBag: DisposeBag?
    @IBOutlet private weak var firstPlayerLabel: UILabel!
    
    deinit {
        print("FireTVManagerExampleViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let disposeBag = DisposeBag()
        self.disposeBag = disposeBag

        do {
            fireTVManager = try FireTVManager()

            try fireTVManager?.startDiscovery(forPlayerID: "amzn.thin.pl")

            fireTVManager?.devicesObservable
                .subscribe(onNext: { [weak self] player in
                    if !player.isEmpty {
                        self?.firstPlayerLabel?.text = player.first?.name()
                    } else {
                        self?.firstPlayerLabel.text = "No player found"
                    }
                }, onError: { error in
                    print(error)
                }).disposed(by: disposeBag)
        } catch {
            print(error)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fireTVManager?.stopDiscovery()
    }
    
    @IBAction private func didPressCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
