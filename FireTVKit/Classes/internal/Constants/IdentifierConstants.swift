//
//  IdentifierConstants.swift
//  FireTVKit
//
//  Created by crelies on 02.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import Foundation

struct IdentifierConstants {
    struct Bundle {
        static let resource = "FireTVKit"
        static let extensionName = "bundle"
    }
    
    struct Date {
        static let logFormat = "yyyy-MM-dd hh:mm:ssSSS"
    }
    
    struct Image {
        static let rewind10sDisabled = "ic_jump_back_10_disabled_dark_48dp"
        static let rewind10s = "ic_jump_back_10_default_dark_48dp"
        static let playDisabled = "ic_play_disabled_dark_48dp"
        static let play = "ic_play_default_dark_48dp"
        static let pauseDisabled = "ic_pause_disabled_dark_48dp"
        static let pause = "ic_pause_default_dark_48dp"
        static let stopDisabled = "ic_stop_disabled_dark_48dp"
        static let stop = "ic_stop_default_dark_48dp"
        static let fastForward10sDisabled = "ic_jump_forward_10_disabled_dark_48dp"
        static let fastForward10s = "ic_jump_forward_10_default_dark_48dp"
        static let close = "close"
    }
	
	struct Metadata {
		struct Keys {
			static let noreplay = "noreplay"
			static let title = "title"
			static let poster = "poster"
			static let type = "type"
			static let description = "description"
		}
	}
    
    struct TableView {
        struct Cell {
            static let fireTVSelection = "FireTVSelectionTableViewCell"
        }
    }
    
    struct Storyboard {
        static let fireTVSelection = "FireTVSelection"
        static let fireTVPlayer = "FireTVPlayer"
    }
    
    struct UserDefaults {
        struct Keys {
            static let fireTVKitLogging = "FireTVKitLogging"
            static let fireTVKitLogEvent = "FireTVKitLogEvent"
        }
    }
}
