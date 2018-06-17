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
    /// Type of the media represented by the `Metadata`, for example `MetadataType.video`
    ///
	public let type: MetadataType
    /// Title of the media represented by the `Metadata`
    ///
	public var title: String?
    /// Description of the media represented by the `Metadata`
    ///
	public var description: String? // optional
    /// URL string of the album art for an audio media source
    ///
    public private(set) var poster: String?
    /// Subtitles of the media represented by the `Metadata`
    ///
	public var tracks: [Subtitle]?
    /// Boolean indicating if the media should replay
    ///
	public var noreplay: Bool?
	
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
