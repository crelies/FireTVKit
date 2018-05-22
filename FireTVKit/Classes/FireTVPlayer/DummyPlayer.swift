//
//  DummyPlayer.swift
//  FireTVKit
//
//  Created by crelies on 16.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation

public final class DummyPlayer: RemoteMediaPlayer {
	public init() {
		
	}
	
	public func name() -> String! {
		return "DummyPlayer"
	}
	
	public func uniqueIdentifier() -> String! {
		return "DummyPlayerID"
	}
	
	public func getVolume() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
	public func setVolume(_ volume: Double) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
	public func isMute() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
	public func setMute(_ mute: Bool) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
	public func getPosition() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: NSNumber(value: 5948))
	}
	
	public func getDuration() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: NSNumber(value: 178934))
	}
	
	public func getStatus() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: MediaPlayerStatus(state: ReadyToPlay, andCondition: Good))
	}
	
	public func isMimeTypeSupported(_ mimeType: String!) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: NSString(string: "true"))
	}
	
	public func pause() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
	public func play() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
	public func stop() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
	public func seek(toPosition positionMilliseconds: Int64, andMode seekMode: SeekType) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
	public func setMediaSourceToURL(_ mediaLoc: String!, metaData: String!, autoPlay: Bool, andPlayInBackground playInBg: Bool) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
	public func add(_ listener: MediaPlayerStatusListener!) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
	public func remove(_ listener: MediaPlayerStatusListener!) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
	public func setPositionUpdateInterval(_ intervalMs: Int64) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
	public func sendCommand(_ cmd: String!) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
	public func setPlayerStyle(_ styleJson: String!) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: nil)
	}
	
	public func getMediaInfo() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: MediaPlayerInfo(source: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", metaData: "{\"title\": \"Testvideo\", \"description\": \"Only use for test purposes\", \"type\": \"video\"}", andExtra: ""))
	}
}
