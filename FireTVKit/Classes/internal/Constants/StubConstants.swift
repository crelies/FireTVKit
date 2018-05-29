//
//  StubConstants.swift
//  FireTVKit
//
//  Created by crelies on 28.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

struct StubConstants {
	struct Metadata {
		static let title = "Testvideo"
		static let description = "This is a testvideo"
		static let poster = URL(string: "https://www.google.de")!
		static let noreplay = true
	}
	
    struct Player {
        static let name = "DummyPlayer"
        static let uniqueIdentifier = "DummyPlayerID"
        static let position = 5948
        static let duration = 178934
        static let isMimeTypeSupported = NSString(string: "true")
        static let source = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        static let metaData = "{\"title\": \"Testvideo\", \"description\": \"Only use for test purposes\", \"type\": \"video\"}"
        static let extra = ""
    }
	
	struct Subtitle {
		
	}
}
