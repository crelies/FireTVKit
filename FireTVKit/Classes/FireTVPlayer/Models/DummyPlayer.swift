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
		return StubConstants.Player.name
	}
	
	public func uniqueIdentifier() -> String! {
		return StubConstants.Player.uniqueIdentifier
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
		return BFTask<AnyObject>(result: NSNumber(value: StubConstants.Player.position))
	}
	
	public func getDuration() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: NSNumber(value: StubConstants.Player.duration))
	}
	
	public func getStatus() -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: MediaPlayerStatus(state: ReadyToPlay, andCondition: Good))
	}
	
	public func isMimeTypeSupported(_ mimeType: String!) -> BFTask<AnyObject>! {
		return BFTask<AnyObject>(result: StubConstants.Player.isMimeTypeSupported)
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
		return BFTask<AnyObject>(result: MediaPlayerInfo(source: StubConstants.Player.source, metaData: StubConstants.Player.metaData, andExtra: StubConstants.Player.extra))
	}
}
