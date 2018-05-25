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
	
    init(dependencies: PlayerServiceDependenciesProtocol, withPlayer player: RemoteMediaPlayer?) {
		self.player = player
		playerDataVariable = Variable<PlayerData?>(nil)
	}
	
	func connectToPlayer(_ newPlayer: RemoteMediaPlayer) -> Completable {
		return Completable.create { completable in
			let timeToWait = DispatchTime.now() + 1.5
			DispatchQueue.main.asyncAfter(deadline: timeToWait) {
				completable(.completed)
			}
			
            let mediaPlayerStatus: MediaPlayerStatus = MediaPlayerStatus(state: ReadyToPlay, andCondition: Good)
            self.playerDataVariable.value = PlayerData(status: mediaPlayerStatus, position: 5948)
			
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
    
    func getPlayerInfo() -> Single<MediaPlayerInfo> {
        return Single.create { single in
			let playerInfo: MediaPlayerInfo = MediaPlayerInfo(source: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", metaData: "{\"title\": \"Testvideo\", \"description\": \"Only use for test purposes\", \"type\": \"video\"}", andExtra: "")
            single(.success(playerInfo))
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
			let timeToWait = DispatchTime.now() + 1.5
			DispatchQueue.main.asyncAfter(deadline: timeToWait) {
				completable(.completed)
			}
			return Disposables.create()
		}
	}
}
