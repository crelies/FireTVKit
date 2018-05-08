//
//  RemoteMediaPlayerProtocol.swift
//  FireTVKit
//
//  Created by crelies on 08.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

public protocol RemoteMediaPlayerProtocol: RemoteMediaPlayer {
    var name: String { get }
    var uniqueIdentifier: String { get }
    
    func getVolume() -> BFTask<AnyObject>
    func setVolume(volume: Double) -> BFTask<AnyObject>
    func isMute() -> BFTask<AnyObject>
    func setMute(mute: Bool) -> BFTask<AnyObject>
    func getPosition() -> BFTask<AnyObject>
    func getDuration() -> BFTask<AnyObject>
    func getStatus() -> BFTask<MediaPlayerStatus>
    func isMimeTypeSupported(mimeType: String) -> BFTask<AnyObject>
    func play() -> BFTask<AnyObject>
    func pause() -> BFTask<AnyObject>
    func stop() -> BFTask<AnyObject>
    func seek(toPosition position: Int64, andMode mode: SeekType) -> BFTask<AnyObject>
    func setMediaSourceToURL(mediaLoc: String, metaData: String, autoPlay: Bool, andPlayInBackground playInBackground: Bool) -> BFTask<AnyObject>
    func add(listener: MediaPlayerStatusListener) -> BFTask<AnyObject>
    func remove(listener: MediaPlayerStatusListener) -> BFTask<AnyObject>
    func setPositionUpdateInterval(intervalMs: Int64) -> BFTask<AnyObject>
    func setPlayerStyle(styleJson: String) -> BFTask<AnyObject>
    func getMediaInfo() -> BFTask<AnyObject>
}
