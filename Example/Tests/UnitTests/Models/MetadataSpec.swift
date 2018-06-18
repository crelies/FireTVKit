//
//  MetadataSpec.swift
//  FireTVKit-Tests
//
//  Created by crelies on 28.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

@testable import FireTVKit
import Foundation
import Nimble
import Quick

final class MetadataSpec: QuickSpec {
    override func spec() {
        describe("Metadata") {
			context("when initialized with all properties except tracks") {
				it("should encode to json string") {
					do {
						let metadata = Metadata(type: .video, title: StubConstants.Metadata.title, description: StubConstants.Metadata.description, poster: StubConstants.Metadata.poster, tracks: nil, noreplay: StubConstants.Metadata.noreplay)
						let data = try JSONEncoder().encode(metadata)
						if let jsonString = String(data: data, encoding: .utf8) {
							let poster = StubConstants.Metadata.poster.absoluteString.replacingOccurrences(of: "/", with: "\\/")
							expect(jsonString) == "{\"\(IdentifierConstants.Metadata.Keys.noreplay)\":\(StubConstants.Metadata.noreplay),\"\(IdentifierConstants.Metadata.Keys.title)\":\"\(StubConstants.Metadata.title)\",\"\(IdentifierConstants.Metadata.Keys.poster)\":\"\(poster)\",\"\(IdentifierConstants.Metadata.Keys.type)\":\"\(MetadataType.video.rawValue)\",\"\(IdentifierConstants.Metadata.Keys.description)\":\"\(StubConstants.Metadata.description)\"}"
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
