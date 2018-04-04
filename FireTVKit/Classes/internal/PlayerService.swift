//
//  PlayerService.swift
//  FireTVKit
//
//  Created by crelies on 28.02.2017.
//  Copyright © 2017 Christian Elies. All rights reserved.
//

import AmazonFling
import RxSwift
import UIKit

internal final class PlayerService: NSObject, PlayerServiceProtocol {
    var player: RemoteMediaPlayer {
        willSet {
            // disconnect current player
            disconnect(fromPlayer: player)
                .subscribe(onCompleted: {
                    // connect to new player
                    self.connect(toPlayer: newValue)
                        .subscribe(onSuccess: { playerData in
                            self.playerDataVariable.value = playerData
                        }).disposed(by: self.disposeBag)
                }) { _ in
                    // connect to new player
                    self.connect(toPlayer: newValue)
                        .subscribe(onSuccess: { playerData in
                            self.playerDataVariable.value = playerData
                        }).disposed(by: self.disposeBag)
                }.disposed(by: disposeBag)
        }
    }
    
    private var playerDataVariable: Variable<PlayerData?>
    var playerData: Observable<PlayerData?> {
        return playerDataVariable.asObservable()
    }
	private let disposeBag: DisposeBag
	
    init(withPlayer player: RemoteMediaPlayer) {
        self.player = player
        playerDataVariable = Variable<PlayerData?>(nil)
        disposeBag = DisposeBag()
        
        super.init()
        
        connect(toPlayer: player)
            .subscribe(onSuccess: { playerData in
                self.playerDataVariable.value = playerData
            }).disposed(by: disposeBag)
    }
    
    deinit {
        _ = disconnect(fromPlayer: player).subscribe(onCompleted: {
            // TODO:
        })
    }
    
    // MARK: - player control
    func play() -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
            let _ = self.player.play().continue({ task -> Any? in
                if let error = task.error {
                    DispatchQueue.main.async {
                        completable(.error(error))
                    }
                } else {
                    DispatchQueue.main.async {
                        completable(.completed)
                    }
                }
                
                return nil
            })
			
			return Disposables.create()
		})
    }
    
    // TODO: metadata encodable
    func play(withMetadata metadata: String, url: String, autoPlay: Bool, playInBackground: Bool) -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
            let _ = self.player.setMediaSourceToURL(url, metaData: metadata, autoPlay: autoPlay, andPlayInBackground: playInBackground).continue({ task -> Any? in
                if let error = task.error {
                    DispatchQueue.main.async {
                        completable(.error(error))
                    }
                } else {
                    DispatchQueue.main.async {
                        completable(.completed)
                    }
                }
                
                return nil
            })
			
			return Disposables.create()
		})
    }
    
    func pause() -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
            let _ = self.player.pause().continue({ task -> Any? in
                if let error = task.error {
                    DispatchQueue.main.async {
                        completable(.error(error))
                    }
                } else {
                    DispatchQueue.main.async {
                        completable(.completed)
                    }
                }
                
                return nil
            })
			
			return Disposables.create()
		})
    }
    
    func setPosition(position: Int64) -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
            let _ = self.player.seek(toPosition: position, andMode: ABSOLUTE).continue({ task -> Any? in
                if let error = task.error {
                    DispatchQueue.main.async {
                        completable(.error(error))
                    }
                } else {
                    DispatchQueue.main.async {
                        completable(.completed)
                    }
                }
                
                return nil
            })
			
			return Disposables.create()
		})
    }
    
    func stop() -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
            let _ = self.player.stop().continue({ task -> Any? in
                if let error = task.error {
                    DispatchQueue.main.async {
                        completable(.error(error))
                    }
                } else {
                    DispatchQueue.main.async {
                        completable(.completed)
                    }
                }
                
                return nil
            })
			
			return Disposables.create()
		})
    }
    
    // MARK: - player data
    func update(withStatus status: MediaPlayerStatus, position: Int64) -> Single<PlayerData?> {
		return Single.create(subscribe: { single -> Disposable in
            var playerData = PlayerData(status: status)
            
            let state = status.state()
            switch state.rawValue {
                case 2: // ReadyToPlay
                    self.getDuration()
                        .subscribe(onSuccess: { duration in
                            playerData.duration = duration
                            // TODO: is this necessary anymore?
                            single(.success(playerData))
                        }, onError: { error in
                            single(.error(error))
                        }).disposed(by: self.disposeBag)
                case 3, 4, 5: // Playing, Paused, Seeking
                    playerData.position = position
                    DispatchQueue.main.async {
                        single(.success(playerData))
                    }
                default:
                    DispatchQueue.main.async {
                        single(.success(nil))
                    }
            }
			
			return Disposables.create()
		})
    }
}

extension PlayerService: MediaPlayerStatusListener {
    func onStatusChange(_ status: MediaPlayerStatus!, positionChangedTo position: Int64) {
        update(withStatus: status, position: position)
            .subscribe(onSuccess: { playerData in
                self.playerDataVariable.value = playerData
            }).disposed(by: disposeBag)
    }
}

extension PlayerService {
    // MARK: - player connection
    private func connect(toPlayer player: RemoteMediaPlayer) -> Single<PlayerData?> {
        return Single.create(subscribe: { single -> Disposable in
            _ = player.add(self).continue({ task -> Any? in
                if let error = task.error {
                    DispatchQueue.main.async {
                        single(.error(error))
                    }
                } else {
                    self.getPlayerData()
                        .subscribe(onSuccess: { currentPlayerData in
                            single(.success(currentPlayerData))
                        }, onError: { error in
                            single(.error(error))
                        }).disposed(by: self.disposeBag)
                }
                
                return nil
            })
            
            return Disposables.create()
        })
    }
    
    private func disconnect(fromPlayer player: RemoteMediaPlayer) -> Completable {
        return Completable.create(subscribe: { completable -> Disposable in
            _ = player.remove(self).continue({ task -> Any? in
                if let error = task.error {
                    DispatchQueue.main.async {
                        completable(.error(error))
                    }
                } else {
                    DispatchQueue.main.async {
                        completable(.completed)
                    }
                }
                
                return nil
            })
            
            return Disposables.create()
        })
    }
    
    // MARK: - player data
    private func getDuration() -> Single<Int?> {
        return Single.create(subscribe: { single -> Disposable in
            let _ = self.player.getDuration().continue({ task -> Any? in
                if let error = task.error {
                    DispatchQueue.main.async {
                        single(.error(error))
                    }
                } else {
                    if let duration = task.result as? Int {
                        DispatchQueue.main.async {
                            single(.success(duration))
                        }
                    } else {
                        DispatchQueue.main.async {
                            single(.success(nil))
                        }
                    }
                }
                
                return nil
            })
            
            return Disposables.create()
        })
    }
    
    private func getPosition() -> Single<Int64?> {
        return Single.create(subscribe: { single -> Disposable in
            let _ = self.player.getPosition().continue({ task -> Any? in
                if let error = task.error {
                    DispatchQueue.main.async {
                        single(.error(error))
                    }
                } else {
                    if let position = task.result as? Int64 {
                        DispatchQueue.main.async {
                            single(.success(position))
                        }
                    } else {
                        DispatchQueue.main.async {
                            single(.success(nil))
                        }
                    }
                }
                
                return nil
            })
            
            return Disposables.create()
        })
    }
    
    private func getPlayerData() -> Single<PlayerData?> {
        return Single.create(subscribe: { single -> Disposable in
            let _ = self.player.getStatus().continue({ task -> Any? in
                
                if let error = task.error {
                    DispatchQueue.main.async {
                        single(.error(error))
                    }
                } else {
                    if let status = task.result as? MediaPlayerStatus {
                        let statusRawValue = status.state().rawValue
                        
                        var currentPlayerData = PlayerData(status: status)
                        
                        if statusRawValue != 7 && statusRawValue != 0 && statusRawValue != 6 {
                            self.getDuration()
                                .subscribe(onSuccess: { duration in
                                    self.getPosition()
                                        .subscribe(onSuccess: { position in
                                            currentPlayerData.duration = duration
                                            currentPlayerData.position = position
                                            single(.success(currentPlayerData))
                                        }, onError: { error in
                                            single(.error(error))
                                        }).disposed(by: self.disposeBag)
                                }, onError: { error in
                                    single(.error(error))
                                }).disposed(by: self.disposeBag)
                        } else {
                            DispatchQueue.main.async {
                                single(.success(currentPlayerData))
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            single(.success(nil))
                        }
                    }
                }
                
                return nil
            })
            
            return Disposables.create()
        })
    }
}
