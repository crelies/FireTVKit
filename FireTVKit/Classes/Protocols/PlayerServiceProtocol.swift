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

/// Represents the requirements of a `PlayerService`
///
public protocol PlayerServiceProtocol {
    /// The player managed by the service
    ///
    var player: RemoteMediaPlayer? { get set }
    /// Observable stream of player data emitted during playback
    ///
    var playerData: Observable<PlayerData?> { get }
    /// Initializes the service
    ///
    /// - Parameters:
    ///   - dependencies: player service dependencies
    ///   - player: player which should be managed and controlled
    ///
    init(dependencies: PlayerServiceDependenciesProtocol, withPlayer player: RemoteMediaPlayer?)
    /// Connects to the given player to receive player status feedback
    ///
    /// - Parameter newPlayer: player to connect to
    /// - Returns: an observable to get notified about a successful connection or an error
    ///
    func connectToPlayer(_ newPlayer: RemoteMediaPlayer) -> Completable
    /// Tries to play the player handled by the service
    ///
    /// - Returns: an observable to get notified about a successful action or an error
    ///
    func play() -> Completable
    /// Plays the given url with the passed metadata on the player handled by the service
    ///
    /// - Parameters:
    ///   - metadata: metadata describing the media at the given url
    ///   - url: the url of the media which should be played
    /// - Returns: an observable to get notified about a successful action or an error
    ///
    func play(withMetadata metadata: Metadata, url: String) -> Completable
    /// Pauses the current playback of the player handled by the service
    ///
    /// - Returns: an observable to get notified about a successful action or an error
    ///
    func pause() -> Completable
    /// Modifies the playback position of the player handled by the service
    ///
    /// - Parameters:
    ///   - position: position to seek to
    ///   - type: seek type, to be able to set an absolute position or a relative position
    /// - Returns: an observable to get notified about a successful action or an error
    ///
    func setPosition(position: Int64, type: SeekType) -> Completable
    /// Stops the playback of the player handled by the service
    ///
    /// - Returns: an observable to get notified about a successful action or an error
    ///
    func stop() -> Completable
    /// Gets the `MediaPlayerInfo` of the player handled by the service (url and metadata of the currently played media)
    ///
    /// - Returns: an observable to get the `MediaPlayerInfo` on success or an error
    ///
    func getPlayerInfo() -> Single<MediaPlayerInfo>
    /// Gets the data of the player handled by service (current status and position of the player)
    ///
    /// - Returns: an observable to get the `PlayerData` on success or an error
    ///
	func getPlayerData() -> Single<PlayerData>
    /// Fetches the duration of the currently played media
    ///
    /// - Returns: an observable to get the duration on success or an error
    ///
	func getDuration() -> Single<Int64>
    /// Fetches the current playback position of the player handled by the service
    ///
    /// - Returns: an observable to get the position on success or an error
    ///
	func getPosition() -> Single<Int64>
    /// Disconnects from the player handled by the service
    ///
    /// - Returns: an observable to get notified about a successful disconnection or an error
    /// - Throws: an error if service has no player
    ///
    func disconnectFromCurrentPlayer() throws -> Completable
    /// Disconnects from the given player
    ///
    /// - Parameter player: player to disconnect from
    /// - Returns: an observable to get notified about a successful disconnection or an error
    ///
    func disconnect(fromPlayer player: RemoteMediaPlayer) -> Completable
}
