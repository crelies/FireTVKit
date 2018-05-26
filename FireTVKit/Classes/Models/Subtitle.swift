//
//  Subtitle.swift
//  FireTVKit
//
//  Created by crelies on 04.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

public struct Subtitle: Codable {
	public let src: String // required – URL of the WebVTT file
	public let kind: SubtitleKind // required – always "subtitles"
	public let srclang: String // required – language code
	public let label: String // required – what is shown on the UI
    
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
