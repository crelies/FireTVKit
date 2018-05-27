//
//  ReachabilityService.swift
//  FireTVKit
//
//  Created by crelies on 27.03.2017.
//  Copyright © 2017 Christian Elies. All rights reserved.
//

import Reachability
import RxSwift
import UIKit

protocol ReachabilityServiceProvider {
    var reachabilityService: ReachabilityServiceProtocol { get }
}

final class ReachabilityService: ReachabilityServiceProtocol {
	private var reachabilityInfo: Variable<Reachability?>
    
    private(set) var reachability: Reachability
    var reachabilityObservable: Observable<Reachability> {
        return reachabilityInfo
            .asObservable()
            .flatMap { Observable.from(optional: $0) }
    }
    private(set) var listeningReachability: Bool
    
    init?() {
        guard let reachability = Reachability() else {
            return nil
        }
        
        self.reachability = reachability
		reachabilityInfo = Variable<Reachability?>(nil)
        listeningReachability = false
        
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async { [weak self] in
				self?.reachabilityInfo.value = reachability
            }
        }
        
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async { [weak self] in
                self?.reachabilityInfo.value = reachability
            }
        }
    }
    
    func startListening() throws {
        try reachability.startNotifier()
        listeningReachability = true
    }
    
    func stopListening() {
        reachability.stopNotifier()
        listeningReachability = false
    }
}
