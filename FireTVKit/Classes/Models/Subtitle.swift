//
//  Subtitle.swift
//  FireTVKit
//
//  Created by crelies on 04.04.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

// TODO: Outsource
enum SubtitleKind: String {
	case subtitles
}

public struct Subtitle: Codable {
	let src: String // required – URL of the WebVTT file
	let kind: String // required – always "subtitles"
	let srclang: String // required – language code
	let label: String // required – what is shown on the UI
}
