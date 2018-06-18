//
//  MetadataType.swift
//  FireTVKit
//
//  Created by crelies on 26.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Enum for the possible metadata types
///
/// - audio: the media is audio
/// - drm: the media is drm
/// - image: the media is an image
/// - video: the media is a video
///
public enum MetadataType: String, Codable {
    case audio
    case drm
    case image
    case video
}
