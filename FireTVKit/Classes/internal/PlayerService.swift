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
    private var player: RemoteMediaPlayer?
    private var playerData: PlayerData?
	private let disposeBag: DisposeBag
	
    init(player: RemoteMediaPlayer) {
        disposeBag = DisposeBag()
		super.init()
        
        connect(toPlayer: player).subscribe(onSuccess: { playerData in
            
        }, onError: { error in
            
        }).disposed(by: disposeBag)
	}
    
    deinit {
        _ = disconnect(fromPlayer: player).subscribe(onCompleted: { }) { _ in }
    }
    
    // MARK: - player control
    func play() -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
			if let currentPlayer = self.player {
				let _ = currentPlayer.play().continue({ task -> Any? in
					DispatchQueue.main.async {
						if let error = task.error {
							completable(.error(error))
						} else {
							completable(.completed)
						}
					}
					
					return nil
				})
			} else {
				completable(.completed)
			}
			
			return Disposables.create()
		})
    }
    
    func play(withMetadata metadata: String, url: String, autoPlay: Bool, playInBackground: Bool) -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
			if let currentPlayer = self.player {
				let _ = currentPlayer.setMediaSourceToURL(url, metaData: metadata, autoPlay: autoPlay, andPlayInBackground: playInBackground).continue({ task -> Any? in
					DispatchQueue.main.async {
						if let error = task.error {
							completable(.error(error))
						} else {
							completable(.completed)
						}
					}
					
					return nil
				})
			} else {
				completable(.completed)
			}
			
			return Disposables.create()
		})
    }
    
    func pause() -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
			if let currentPlayer = self.player {
				let _ = currentPlayer.pause().continue({ task -> Any? in
					DispatchQueue.main.async {
						if let error = task.error {
							completable(.error(error))
						} else {
							completable(.completed)
						}
					}
					
					return nil
				})
			} else {
				completable(.completed)
			}
			
			return Disposables.create()
		})
    }
    
    func setPosition(position: Int64) -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
			if let currentPlayer = self.player {
				let _ = currentPlayer.seek(toPosition: position, andMode: ABSOLUTE).continue({ task -> Any? in
					DispatchQueue.main.async {
						if let error = task.error {
							completable(.error(error))
						} else {
							completable(.completed)
						}
					}
					
					return nil
				})
			} else {
				completable(.completed)
			}
			
			return Disposables.create()
		})
    }
    
    func stop() -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
			if let currentPlayer = self.player {
				let _ = currentPlayer.stop().continue({ task -> Any? in
					DispatchQueue.main.async {
						if let error = task.error {
							completable(.error(error))
						} else {
							completable(.completed)
						}
					}
					
					return nil
				})
			} else {
				completable(.completed)
			}
			
			return Disposables.create()
		})
    }
    
    // MARK: - player data
    func update(withStatus status: MediaPlayerStatus, position: Int64) -> Single<PlayerData?> {
		return Single.create(subscribe: { single -> Disposable in
			if let _ = self.player {
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
						single(.success(playerData))
					default:
						single(.success(nil))
				}
			} else {
				single(.success(nil))
			}
			
			return Disposables.create()
		})
    }
    
    // MARK: - player connection
    func disconnect() -> Completable {
        return disconnect(fromPlayer: player)
    }
}

extension PlayerService: MediaPlayerStatusListener {
    func onStatusChange(_ status: MediaPlayerStatus!, positionChangedTo position: Int64) {
        update(withStatus: status, position: position)
            .subscribe(onSuccess: { playerData in
                self.playerData = playerData
            }) { _ in
                // TODO:
            }.disposed(by: disposeBag)
    }
}

extension PlayerService {
    // MARK: - player connection
    private func connect(toPlayer player: RemoteMediaPlayer) -> Single<PlayerData?> {
        return Single.create(subscribe: { single -> Disposable in
            if self.player == nil {
                self.player = player
                
                let _ = player.add(self).continue({ task -> Any? in
                    DispatchQueue.main.async {
                        if let error = task.error {
                            single(.error(error))
                        } else {
                            self.getPlayerData()
                                .subscribe(onSuccess: { currentPlayerData in
                                    single(.success(currentPlayerData))
                                }, onError: { error in
                                    single(.error(error))
                                }).disposed(by: self.disposeBag)
                        }
                    }
                    
                    return nil
                })
            } else {
                if let currentPlayer = self.player,
                    currentPlayer !== player {
                    currentPlayer.remove(self).continue({ task -> Any? in
                        DispatchQueue.main.async {
                            if let error = task.error {
                                single(.error(error))
                            } else {
                                self.player = player
                                
                                let _ = player.add(self).continue({ task -> Any? in
                                    DispatchQueue.main.async {
                                        if let error = task.error {
                                            single(.error(error))
                                        } else {
                                            self.getPlayerData()
                                                .subscribe(onSuccess: { currentPlayerData in
                                                    single(.success(currentPlayerData))
                                                }, onError: { error in
                                                    single(.error(error))
                                                }).disposed(by: self.disposeBag)
                                        }
                                    }
                                    
                                    return nil
                                })
                            }
                        }
                        
                        return nil
                    })
                } else {
                    single(.success(nil))
                }
            }
            
            return Disposables.create()
        })
    }
    
    private func disconnect(fromPlayer player: RemoteMediaPlayer?) -> Completable {
        return Completable.create(subscribe: { completable -> Disposable in
            if let player = player {
                let _ = player.remove(self).continue({ task -> Any? in
                    DispatchQueue.main.async {
                        if let error = task.error {
                            completable(.error(error))
                        } else {
                            if let currentPlayer = self.player, currentPlayer === player {
                                self.player = nil
                            }
                            
                            completable(.completed)
                        }
                    }
                    
                    return nil
                })
            } else {
                completable(.completed)
            }
            
            return Disposables.create()
        })
    }
    
    // MARK: - player data
    private func getDuration() -> Single<Int?> {
        return Single.create(subscribe: { single -> Disposable in
            if let currentPlayer = self.player {
                let _ = currentPlayer.getDuration().continue({ task -> Any? in
                    DispatchQueue.main.async {
                        if let error = task.error {
                            single(.error(error))
                        } else {
                            if let duration = task.result as? Int {
                                single(.success(duration))
                            } else {
                                single(.success(nil))
                            }
                        }
                    }
                    
                    return nil
                })
            } else {
                single(.success(nil))
            }
            
            return Disposables.create()
        })
    }
    
    private func getPosition() -> Single<Int64?> {
        return Single.create(subscribe: { single -> Disposable in
            if let currentPlayer = self.player {
                let _ = currentPlayer.getPosition().continue({ task -> Any? in
                    DispatchQueue.main.async {
                        if let error = task.error {
                            single(.error(error))
                        } else {
                            if let position = task.result as? Int64 {
                                single(.success(position))
                            } else {
                                single(.success(nil))
                            }
                        }
                    }
                    
                    return nil
                })
            } else {
                single(.success(nil))
            }
            
            return Disposables.create()
        })
    }
    
    private func getPlayerData() -> Single<PlayerData?> {
        return Single.create(subscribe: { single -> Disposable in
            if let currentPlayer = self.player {
                let _ = currentPlayer.getStatus().continue({ task -> Any? in
                    DispatchQueue.main.async {
                        if let error = task.error {
                            single(.error(error))
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
                                    single(.success(currentPlayerData))
                                }
                            } else {
                                single(.success(nil))
                            }
                        }
                    }
                    
                    return nil
                })
            } else {
                single(.success(nil))
            }
            
            return Disposables.create()
        })
    }
}
