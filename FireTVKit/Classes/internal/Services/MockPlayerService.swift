//
//  MockPlayerService.swift
//  FireTVKit
//
//  Created by crelies on 17.05.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation
import RxSwift

final class MockPlayerService: PlayerServiceProtocol {
	var player: RemoteMediaPlayer?
	var playerData: Observable<PlayerData?> {
		return playerDataVariable.asObservable()
	}
	
	private let playerDataVariable: Variable<PlayerData?>
	
	init(withPlayer player: RemoteMediaPlayer?) {
		self.player = player
		playerDataVariable = Variable<PlayerData?>(nil)
	}
	
	func connectToPlayer(_ newPlayer: RemoteMediaPlayer) -> Completable {
		return Completable.create { completable in
			completable(.completed)
			return Disposables.create()
		}
	}
	
	func play() -> Completable {
		return Completable.create { completable in
			completable(.completed)
			return Disposables.create()
		}
	}
	
	func play(withMetadata metadata: Metadata, url: String) -> Completable {
		return Completable.create { completable in
			completable(.completed)
			return Disposables.create()
		}
	}
	
	func pause() -> Completable {
		return Completable.create { completable in
			completable(.completed)
			return Disposables.create()
		}
	}
	
	func setPosition(position: Int64, type: SeekType) -> Completable {
		return Completable.create { completable in
			completable(.completed)
			return Disposables.create()
		}
	}
	
	func stop() -> Completable {
		return Completable.create { completable in
			completable(.completed)
			return Disposables.create()
		}
	}
	
	func getPlayerData() -> Single<PlayerData> {
		return Single.create { single in
			let mediaPlayerStatus: MediaPlayerStatus = MediaPlayerStatus(state: ReadyToPlay, andCondition: Good)
			let playerData: PlayerData = PlayerData(status: mediaPlayerStatus, position: 5948)
			single(.success(playerData))
			return Disposables.create()
		}
	}
	
	func getDuration() -> Single<Int64> {
		return Single.create { single in
			single(.success(178934))
			return Disposables.create()
		}
	}
	
	func getPosition() -> Single<Int64> {
		return Single.create { single in
			single(.success(5948))
			return Disposables.create()
		}
	}
	
	func disconnect(fromPlayer player: RemoteMediaPlayer) -> Completable {
		return Completable.create { completable in
			completable(.completed)
			return Disposables.create()
		}
	}
}
