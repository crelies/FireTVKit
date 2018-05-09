//
//  Metadata.swift
//  FireTVKit
//
//  Created by crelies on 04.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

// TODO: Outsource
enum MetadataType: String {
	case video
}

public struct Metadata: Encodable {
	public let type: String // required (if not present, video is assumed)
	public var title: String? // optional
	public var description: String? // optional
	public var poster: String? // optional – URL of the album art for an audio media source
	public var tracks: [Subtitle]? // optional – subtitles presented to the user
	public var noreplay: Bool?  //optional
	
	public init(type: String) {
		self.type = type
	}
}
