//
//  DummyPlayer.swift
//  FireTVKit
//
//  Created by crelies on 16.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

/// Mock FireTV / player
/// Use only for testing purposes
///
public final class DummyPlayer: RemoteMediaPlayer {
    /// Initializes the player
    ///
	public init() {
		
	}
	
    /// Returns the name of player
    ///
    /// - Returns: "DummyPlayer"
    ///
	public func name() -> String! {
		return StubConstants.Player.name
	}
	
    /// Returns the unique identifier of the player
    ///
    /// - Returns: "DummyPlayerID"
    ///
	public func uniqueIdentifier() -> String! {
		return StubConstants.Player.uniqueIdentifier
	}
	
    /// Returns the current volume of the player
    /// The volume api is currently not supported
    /// by the built-in receiver app
    ///
    /// - Returns: a nil task result
    ///
	public func getVolume() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
    /// Sets the volume of the player
    /// The volume api is currently not supported
    /// by the built-in receiver app
    ///
    /// - Returns: a nil task result
    ///
	public func setVolume(_ volume: Double) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
    /// Asks the player if he is muted
    /// The mute api is currently not supported
    /// by the built-in receiver app
    ///
    /// - Returns: a nil task result
    ///
	public func isMute() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
    /// Mutes or unmutes the player
    /// The mute api is currently not supported
    /// by the built-in receiver app
    ///
    /// - Returns: a nil task result
    ///
	public func setMute(_ mute: Bool) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
    /// Returns the current position of the player
    ///
    /// - Returns: a `NSNumber` with the value `5948` as task result
    ///
	public func getPosition() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: NSNumber(value: StubConstants.Player.position))
	}
	
    /// Returns the duration of the currently playing media
    ///
    /// - Returns: a `NSNumber` with the value `178934` as task result
    ///
	public func getDuration() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: NSNumber(value: StubConstants.Player.duration))
	}
	
    /// Fetch the current player status
    ///
    /// - Returns: a `MediaPlayerStatus` with the state `ReadyToPlay` and the condition `Good` as task result
    ///
	public func getStatus() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: MediaPlayerStatus(state: ReadyToPlay, andCondition: Good))
	}
	
    /// Asks the player if the given mime type is supported
    ///
    /// - Parameter mimeType: mime type to check
    /// - Returns: the string `true` as task result
    ///
	public func isMimeTypeSupported(_ mimeType: String!) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: StubConstants.Player.isMimeTypeSupported)
	}
	
    /// Pauses the playback on the player
    ///
    /// - Returns: a nil task result
    ///
	public func pause() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
    /// Starts the playback on the player
    ///
    /// - Returns: a nil task result
    ///
	public func play() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
    /// Stops the playback on the player
    ///
    /// - Returns: a nil task result
    ///
	public func stop() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
    /// Seeks the player position to the given milliseconds using the given mode
    ///
    /// - Parameters:
    ///   - positionMilliseconds: position to seek to in milliseconds
    ///   - seekMode: mode to use for the seeking
    /// - Returns: a nil task result
    ///
	public func seek(toPosition positionMilliseconds: Int64, andMode seekMode: SeekType) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
    /// Sets the media source of the player
    ///
    /// - Parameters:
    ///   - mediaLoc: the url of the media which should be played
    ///   - metaData: the metadata of the media
    ///   - autoPlay: indicates if media should be autoplayed, currently not supported by the built-in media receiver
    ///   - playInBg: indicates if media should be played in background, currently not supported by the built-in media receiver
    /// - Returns: a nil task result
    ///
	public func setMediaSourceToURL(_ mediaLoc: String!, metaData: String!, autoPlay: Bool, andPlayInBackground playInBg: Bool) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
    /// Adds a status listener to the player
    /// Currently only one listener is supported by the built-in media receiver
    ///
    /// - Parameter listener: an object conforming to `MediaPlayerStatusListener` which will get status updates from the player
    /// - Returns: a nil task result
    ///
	public func add(_ listener: MediaPlayerStatusListener!) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
    /// Removes the given listener from the playe
    ///
    /// - Parameter listener: listener to remove
    /// - Returns: a nil task result
    ///
	public func remove(_ listener: MediaPlayerStatusListener!) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
    /// Sets the position update interval
    ///
    /// - Parameter intervalMs: update interval in milliseconds
    /// - Returns: a nil task result
    ///
	public func setPositionUpdateInterval(_ intervalMs: Int64) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
    /// Sends the given command to the player
    /// Currently not supported by the built-in media receiver
    ///
    /// - Parameter cmd: the command string
    /// - Returns: a nil task result
    ///
	public func sendCommand(_ cmd: String!) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
    /// Sets the style of the player
    ///
    /// - Parameter styleJson: the json encoded player style
    /// - Returns: a nil task result
    ///
	public func setPlayerStyle(_ styleJson: String!) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
    /// Fetches the info of the currently playing media
    ///
    /// - Returns: a media player info with "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4" as source, "{\"title\": \"Testvideo\", \"description\": \"Only use for test purposes\", \"type\": \"video\"}" as metadata and "" as extra
    ///
	public func getMediaInfo() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: MediaPlayerInfo(source: StubConstants.Player.source, metaData: StubConstants.Player.metaData, andExtra: StubConstants.Player.extra))
	}
}
