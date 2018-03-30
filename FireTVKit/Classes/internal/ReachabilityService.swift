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

internal protocol HasReachabilityService {
    var reachabilityService: ReachabilityServiceProtocol { get set }
}

internal final class ReachabilityService: ReachabilityServiceProtocol {
    private(set) var reachability: Reachability
	private(set) var reachabilityInfo: Variable<Reachability?>
	private(set) var listeningReachability: Bool
    
    init?() {
        guard let reachability = Reachability() else {
            return nil
        }
        
        self.reachability = reachability
		reachabilityInfo = Variable<Reachability?>(nil)
        listeningReachability = false
        
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
				self.reachabilityInfo.value = reachability
            }
        }
        
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                self.reachabilityInfo.value = reachability
            }
        }
    }
    
    func startListening() throws {
        try reachability.startNotifier()
        listeningReachability = true
    }
    
    func checkListening() -> Reachability? {
        if listeningReachability {
            return reachability
		} else {
			return nil
		}
    }
    
    func stopListening() {
        reachability.stopNotifier()
        listeningReachability = false
    }
}
