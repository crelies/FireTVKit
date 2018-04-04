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
    var player: RemoteMediaPlayer { get set }
    var playerData: Observable<PlayerData?> { get }
    init(withPlayer player: RemoteMediaPlayer)
    func play() -> Completable
    func play(withMetadata metadata: Metadata, url: String, autoPlay: Bool, playInBackground: Bool) -> Completable
    func play(withMetadata metadata: Metadata, url: String) -> Completable
    func pause() -> Completable
    func setPosition(position: Int64, type: SeekType) -> Completable
    func stop() -> Completable
}

extension PlayerServiceProtocol {
    public func play(withMetadata metadata: Metadata, url: String) -> Completable {
        return play(withMetadata: metadata, url: url, autoPlay: true, playInBackground: false)
    }
}
