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
			if player.uniqueIdentifier() != newValue.uniqueIdentifier() {
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
            let _ = self.player.play().continue(with: BFExecutor.mainThread(), with: { task -> Any? in
                if let error = task.error {
                    completable(.error(error))
                } else {
                    completable(.completed)
                }
                
                return nil
            })
			
			return Disposables.create()
		})
    }
	
    func play(withMetadata metadata: Metadata, url: String, autoPlay: Bool, playInBackground: Bool) -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
			
			do {
				let metadataData = try JSONEncoder().encode(metadata)
				let metadataString = String(data: metadataData, encoding: .utf8)
				
                let _ = self.player.setMediaSourceToURL(url, metaData: metadataString, autoPlay: autoPlay, andPlayInBackground: playInBackground).continue(with: BFExecutor.mainThread(), with: { task -> Any? in
					if let error = task.error {
                        completable(.error(error))
					} else {
                        completable(.completed)
					}
					
					return nil
				})
			} catch {
				completable(.error(error))
			}
			
			return Disposables.create()
		})
    }
    
    func pause() -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
            let _ = self.player.pause().continue(with: BFExecutor.mainThread(), with: { task -> Any? in
                if let error = task.error {
                    completable(.error(error))
                } else {
                    completable(.completed)
                }
                
                return nil
            })
			
			return Disposables.create()
		})
    }
    
    // TODO: mode
    func setPosition(position: Int64) -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
            let _ = self.player.seek(toPosition: position, andMode: ABSOLUTE).continue(with: BFExecutor.mainThread(), with: { task -> Any? in
                if let error = task.error {
                    completable(.error(error))
                } else {
                    completable(.completed)
                }
                
                return nil
            })
			
			return Disposables.create()
		})
    }
    
    func stop() -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
            let _ = self.player.stop().continue(with: BFExecutor.mainThread(), with: { task -> Any? in
                if let error = task.error {
                    completable(.error(error))
                } else {
                    completable(.completed)
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
            
            var disposable = Disposables.create()
            
            let state = status.state()
            switch state.rawValue {
                case 2: // ReadyToPlay
                    disposable = self.getDuration()
                        .subscribe(onSuccess: { duration in
                            playerData.duration = duration
                            // TODO: is this necessary anymore?
                            single(.success(playerData))
                        }, onError: { error in
                            single(.error(error))
                        })
                case 3, 4, 5: // Playing, Paused, Seeking
                    playerData.position = position
                    single(.success(playerData))
                default:
                    single(.success(nil))
            }
			
			return disposable
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
            var disposable = Disposables.create()
            
            _ = player.add(self).continue(with: BFExecutor.mainThread(), with: { task -> Any? in
                if let error = task.error {
                    single(.error(error))
                } else {
                    disposable = self.getPlayerData()
                        .subscribe(onSuccess: { currentPlayerData in
                            single(.success(currentPlayerData))
                        }, onError: { error in
                            single(.error(error))
                        })
                }
                
                return nil
            })
            
            return disposable
        })
    }
    
    private func disconnect(fromPlayer player: RemoteMediaPlayer) -> Completable {
        return Completable.create(subscribe: { completable -> Disposable in
            _ = player.remove(self).continue(with: BFExecutor.mainThread(), with: { task -> Any? in
                if let error = task.error {
                    completable(.error(error))
                } else {
                    completable(.completed)
                }
                
                return nil
            })
            
            return Disposables.create()
        })
    }
    
    // MARK: - player data
    private func getDuration() -> Single<Int?> {
        return Single.create(subscribe: { single -> Disposable in
            let _ = self.player.getDuration().continue(with: BFExecutor.mainThread(), with: { task -> Any? in
                if let error = task.error {
                    single(.error(error))
                } else {
                    if let duration = task.result as? Int {
                        single(.success(duration))
                    } else {
                        single(.error(PlayerServiceError.couldNotCastDurationToInt))
                    }
                }
                
                return nil
            })
            
            return Disposables.create()
        })
    }
    
    private func getPosition() -> Single<Int64?> {
        return Single.create(subscribe: { single -> Disposable in
            let _ = self.player.getPosition().continue(with: BFExecutor.mainThread(), with: { task -> Any? in
                if let error = task.error {
                    single(.error(error))
                } else {
                    if let position = task.result as? Int64 {
                        single(.success(position))
                    } else {
                        single(.error(PlayerServiceError.couldNotCastPositionToInt64))
                    }
                }
                
                return nil
            })
            
            return Disposables.create()
        })
    }
    
    private func getPlayerData() -> Single<PlayerData?> {
        return Single.create(subscribe: { single -> Disposable in
            
            var disposable = Disposables.create()
            
            let _ = self.player.getStatus().continue(with: BFExecutor.mainThread(), with: { task -> Any? in
                
                if let error = task.error {
                    single(.error(error))
                } else {
                    if let status = task.result as? MediaPlayerStatus {
                        var currentPlayerData = PlayerData(status: status)
                        
                        let statusRawValue = status.state().rawValue
                        switch statusRawValue {
                            case 1, 2, 3, 4, 5:
                                disposable = self.getDuration()
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
                                    })
                            
                            default:
                                single(.success(currentPlayerData))
                        }
                    } else {
                        single(.error(PlayerServiceError.couldNotCastTaskResultToMediaPlayerStatus))
                    }
                }
                
                return nil
            })
            
            return disposable
        })
    }
}
