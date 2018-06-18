//
//  SubtitleSpec.swift
//  FireTVKit-Tests
//
//  Created by crelies on 28.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

@testable import FireTVKit
import Foundation
import Nimble
import Quick

final class SubtitleSpec: QuickSpec {
    override func spec() {
        describe("Subtitle") {
            context("when initializing with all properties") {
                it("should encode to json string") {
                    do {
                        let subtitle = Subtitle(src: StubConstants.Subtitle.src, kind: .subtitles, srclang: StubConstants.Subtitle.srclang, label: StubConstants.Subtitle.label)
                        let data = try JSONEncoder().encode(subtitle)
                        if let jsonString = String(data: data, encoding: .utf8) {
                            let srcUrl = StubConstants.Subtitle.src.absoluteString.replacingOccurrences(of: "/", with: "\\/")
                            expect(jsonString) == "{\"\(IdentifierConstants.Subtitle.Keys.label)\":\"\(StubConstants.Subtitle.label)\",\"\(IdentifierConstants.Subtitle.Keys.kind)\":\"\(SubtitleKind.subtitles.rawValue)\",\"\(IdentifierConstants.Subtitle.Keys.srclang)\":\"\(StubConstants.Subtitle.srclang)\",\"\(IdentifierConstants.Subtitle.Keys.src)\":\"\(srcUrl)\"}"
                        } else {
                            fail("Could not create string from data")
                        }
                    } catch {
                        fail(error.localizedDescription)
                    }
                }
            }
        }
    }
}
