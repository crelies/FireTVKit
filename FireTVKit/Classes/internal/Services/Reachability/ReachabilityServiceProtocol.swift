//
//  ReachabilityServiceProtocol.swift
//  FireTVKit
//
//  Created by crelies on 30.03.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation
import Reachability
import RxSwift

protocol ReachabilityServiceProtocol {
    var reachability: Reachability { get }
    var reachabilityObservable: Observable<Reachability> { get }
    var listeningReachability: Bool { get }
    
    init?()
    func startListening() throws
    func stopListening()
}
