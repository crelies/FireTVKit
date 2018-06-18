//
//  Subtitle.swift
//  FireTVKit
//
//  Created by crelies on 04.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

/// Model representing a subtitle/track for a media
/// A subtitle can be assigned as a track to `Metadata`
/// Conforms to `Codable` and therefore can be encoded to JSON
///
public struct Subtitle: Codable {
    /// URL string of the WebVTT file
    ///
    public let src: String
    /// Type of the subtitle, always `SubtitleKind.subtitles`
    ///
    public let kind: SubtitleKind
    /// Language code of the subtitle
    ///
    public let srclang: String
    /// Text which is shown on the UI
    ///
    public let label: String
    
    /// Initializes using all properties
    ///
    /// - Parameters:
    ///   - src: URL of the WebVTT file
    ///   - kind: Type of the subtitle, currently always `SubtitleKind.subtitles`
    ///   - srclang: Language code of the subtitle, has to be exactly 2 characters
    ///   - label: Text which is shown on the UI
    ///
    public init?(src: URL, kind: SubtitleKind, srclang: String, label: String) {
        guard srclang.count == 2 else {
            return nil
        }
        
        self.src = src.absoluteString
        self.kind = kind
        self.srclang = srclang
        self.label = label
    }
}
