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
    init(player: RemoteMediaPlayer)
    func play() -> Completable
    func play(withMetadata metadata: String, url: String, autoPlay: Bool, playInBackground: Bool) -> Completable
    func play(withMetadata metadata: String, url: String) -> Completable
    func pause() -> Completable
    func setPosition(position: Int64) -> Completable
    func stop() -> Completable
    func update(withStatus status: MediaPlayerStatus, position: Int64) -> Single<PlayerData?>
    func disconnect() -> Completable
}

extension PlayerServiceProtocol {
    public func play(withMetadata metadata: String, url: String) -> Completable {
        return play(withMetadata: metadata, url: url, autoPlay: true, playInBackground: false)
    }
}
