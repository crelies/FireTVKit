//
//  RemoteMediaPlayerProtocol.swift
//  FireTVKit
//
//  Created by crelies on 08.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

public protocol RemoteMediaPlayerProtocol {
    func name() -> String
    func uniqueIdentifier() -> String
    
//    The built-in media player receiver does not support the mute and volume API calls at this time.
//    func getVolume() -> BFTask<AnyObject>
//    func setVolume(volume: Double) -> BFTask<AnyObject>
//    func isMute() -> BFTask<AnyObject>
//    func setMute(mute: Bool) -> BFTask<AnyObject>
    
    func getPosition() -> BFTask<AnyObject>
    func getDuration() -> BFTask<AnyObject>
    func getStatus() -> BFTask<AnyObject>
    func isMimeTypeSupported(mimeType: String) -> BFTask<AnyObject>
    func play() -> BFTask<AnyObject>
    func pause() -> BFTask<AnyObject>
    func stop() -> BFTask<AnyObject>
    func seek(toPosition position: Int64, andMode mode: SeekType) -> BFTask<AnyObject>
    
    // The built-in media player receiver does not support autoplay and playInBg at this time. A custom media player is required to use these options.
    func setMediaSourceToURL(_ mediaLoc: String, metaData: String, autoPlay: Bool, andPlayInBackground playInBackground: Bool) -> BFTask<AnyObject>
    
    func add(_ listener: MediaPlayerStatusListener) -> BFTask<AnyObject>
    func remove(_ listener: MediaPlayerStatusListener) -> BFTask<AnyObject>
    func setPositionUpdateInterval(intervalMs: Int64) -> BFTask<AnyObject>
    
    // The built-in media player receiver does not support the sendCommand API call. The intention of this API call is to allow custom receivers to receive information that can not be included in other API calls.  A custom media player is required to use this API.
//    func sendCommand(cmd: String) -> BFTask<AnyObject>
    
    // The built-in media player receiver does not support setting the player style at this time. A custom media player is required to use this API.
//    func setPlayerStyle(styleJson: String) -> BFTask<AnyObject>
    
    func getMediaInfo() -> BFTask<AnyObject>
}
