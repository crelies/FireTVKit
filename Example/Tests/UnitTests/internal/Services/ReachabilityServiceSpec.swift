//
//  ReachabilityServiceSpec.swift
//  FireTVKit-Tests
//
//  Created by crelies on 28.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

@testable import FireTVKit
import Foundation
import Nimble
import Quick
import Reachability
import RxSwift

final class ReachabilitySpec: QuickSpec {
    override func spec() {
        describe("ReachabilityService") {
            context("when initialized") {
                it("should have reachability property") {
                    do {
                        let service = try ServiceFactory.makeReachabilityService()
                        expect(service.reachability).toNot(beNil())
                    } catch {
                        fail(error.localizedDescription)
                    }
                }
                
                it("should have correct boolean value for listeningReachability") {
                    do {
                        let service = try ServiceFactory.makeReachabilityService()
                        expect(service.listeningReachability) == false
                    } catch {
                        fail(error.localizedDescription)
                    }
                }
            }
            
            context("when start listening was called") {
                it("should have correct boolean value for listeningReachability") {
                    do {
                        let service = try ServiceFactory.makeReachabilityService()
                        try service.startListening()
                        expect(service.listeningReachability) == true
                        service.stopListening()
                    } catch {
                        fail(error.localizedDescription)
                    }
                }
                
                it("should emit reachability") {
                    do {
                        let service = try ServiceFactory.makeReachabilityService()
                        let disposeBag = DisposeBag()
                        
                        var reachability: Reachability?
                        service.reachabilityObservable
                            .subscribe(onNext: { currentReachability in
                                reachability = currentReachability
                            }, onError: { error in
                                fail(error.localizedDescription)
                            }).disposed(by: disposeBag)
                        
                        try service.startListening()
                        
                        expect(reachability).toEventuallyNot(beNil())
                        
                        service.stopListening()
                    } catch {
                        fail(error.localizedDescription)
                    }
                }
            }
            
            context("when stop listening was called") {
                it("should have correct boolean value for listeningReachability") {
                    do {
                        let service = try ServiceFactory.makeReachabilityService()
                        try service.startListening()
                        service.stopListening()
                        expect(service.listeningReachability) == false
                    } catch {
                        fail(error.localizedDescription)
                    }
                }
            }
        }
    }
}
