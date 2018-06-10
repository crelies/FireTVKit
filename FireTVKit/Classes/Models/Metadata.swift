//
//  Metadata.swift
//  FireTVKit
//
//  Created by crelies on 04.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Represents the metadata for media played on a FireTV
/// Conforms to `Codable` to be represented as JSON
///
public struct Metadata: Codable {
	public let type: MetadataType // required (if not present, video is assumed)
	public var title: String? // optional
	public var description: String? // optional
    public private(set) var poster: String? // optional – URL of the album art for an audio media source
	public var tracks: [Subtitle]? // optional – subtitles presented to the user
	public var noreplay: Bool?  //optional
	
    /// Initializes only using a `MetadataType`
    ///
    /// - Parameter type: the type of the metadata
    ///
	public init(type: MetadataType) {
		self.type = type
	}
    
    /// Initializes with all available properties
    ///
    /// - Parameters:
    ///   - type: the type of the media
    ///   - title: the title of the media
    ///   - description: a description for the media
    ///   - poster: a poster for the media
    ///   - tracks: audio/subtitle tracks for the media
    ///   - noreplay: boolean indicating if media should be replayed
    ///
    public init(type: MetadataType, title: String?, description: String?, poster: URL?, tracks: [Subtitle]?, noreplay: Bool?) {
        self.type = type
        self.title = title
        self.description = description
        self.poster = poster?.absoluteString
        self.tracks = tracks
        self.noreplay = noreplay
    }
}
