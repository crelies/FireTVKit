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

public protocol ReachabilityServiceProtocol {
    var reachability: Reachability { get }
    var reachabilityInfo: Variable<Reachability?> { get }
    var listeningReachability: Bool { get }
    
    func startListening() throws
    func checkListening() -> Reachability?
    func stopListening()
}
