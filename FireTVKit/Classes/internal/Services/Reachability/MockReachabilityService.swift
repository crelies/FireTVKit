//
//  MockReachabilityService.swift
//  FireTVKit
//
//  Created by crelies on 27.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation
import Reachability
import RxSwift

final class MockReachabilityService: ReachabilityServiceProtocol {
    var reachability: Reachability
    var reachabilityObservable: Observable<Reachability>
    var listeningReachability: Bool

    init?() {
        guard let reachability = Reachability() else {
            return nil
        }
        
        self.reachability = reachability
        reachabilityObservable = Observable.just(reachability)
        listeningReachability = false
    }
    
    func startListening() throws {
        
    }
    
    func stopListening() {
        
    }
}
