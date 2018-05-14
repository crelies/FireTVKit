//
//  PlayerServiceProtocol.swift
//  FireTVKit
//
//  Created by crelies on 30.03.2018.
//  Copyright © 2018 Christian Elies. All rights reserved.
//

import AmazonFling
import Foundation
import RxSwift

public protocol PlayerServiceProtocol {
    var player: RemoteMediaPlayer? { get }
    var playerData: Observable<PlayerData?> { get }
    init(withPlayer player: RemoteMediaPlayer?)
    func connectToPlayer(_ newPlayer: RemoteMediaPlayer) -> Completable
    func play() -> Completable
    func play(withMetadata metadata: Metadata, url: String) -> Completable
    func pause() -> Completable
    func setPosition(position: Int64, type: SeekType) -> Completable
    func stop() -> Completable
	func getPlayerData() -> Single<PlayerData>
	func getDuration() -> Single<Int64>
	func getPosition() -> Single<Int64>
    func disconnect(fromPlayer player: RemoteMediaPlayer) -> Completable
}
