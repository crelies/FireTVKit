//
//  FireTVMedia.swift
//  FireTVKit
//
//  Created by crelies on 12.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Represents the media which can be played
/// on the built-in receiver app of a FireTV
///
public struct FireTVMedia {
    let metadata: Metadata
    let url: URL
	
    /// Initializes the media
    ///
    /// - Parameters:
    ///   - metadata: metadata describing the media
    ///   - url: url of the media
    ///
	public init(metadata: Metadata, url: URL) {
		self.metadata = metadata
		self.url = url
	}
}
