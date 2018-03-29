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

internal protocol HasPlayerService {
    var playerService: PlayerServiceProtocol { get }
}

internal protocol PlayerServiceProtocol {
	var currentPlayer: RemoteMediaPlayer? { get }
	
	func playCurrentPlayer() -> Completable
	func playCurrentPlayer(with metadata: String, and url: String) -> Completable
	func pauseCurrentPlayer() -> Completable
	func setCurrentPlayer(Position position: Int64) -> Completable
	func stopCurrentPlayer() -> Completable
	func updateCurrentPlayerData(with status: MediaPlayerStatus, and position: Int64) -> Single<CurrentPlayerData?>
	func connect(to player: RemoteMediaPlayer) -> Single<CurrentPlayerData?>
	func disconnect(from player: RemoteMediaPlayer?) -> Completable
	func disconnectFromCurrentPlayer() -> Completable
}

internal final class PlayerService: NSObject, PlayerServiceProtocol {
    private(set) var currentPlayer: RemoteMediaPlayer?
    fileprivate var currentPlayerStatus: MediaPlayerStatus?
	private var disposeBag: DisposeBag
	
	private let dependencies: PlayerServiceDependenciesProtocol
	
	init(dependencies: PlayerServiceDependenciesProtocol) {
		self.dependencies = dependencies
		disposeBag = DisposeBag()
		
		super.init()
		
		dependencies.playerDiscoveryService.deviceInfo.asObservable()
			.subscribe(onNext: { deviceInfo in
				if let deviceInfo = deviceInfo {
					switch deviceInfo.status {
						case .deviceDiscovered:
							if let device = deviceInfo.device {
								let _ = self.connect(to: device)
							}
						default: ()
					}
				}
			}, onError: { _ in
				
			}, onCompleted: {
				
			}).disposed(by: disposeBag)
		
		dependencies.playerDiscoveryService.discoveringInfo.asObservable()
			.subscribe(onNext: { playerDiscoveringInfo in
				if let playerDiscoveringInfo = playerDiscoveringInfo {
					switch playerDiscoveringInfo.status {
						case .stopped:
							self.currentPlayer = nil
							self.currentPlayerStatus = nil
						default: ()
					}
				}
			}, onError: { _ in
				
			}, onCompleted: {
				
			}).disposed(by: disposeBag)
	}
    
    // MARK: - player control
    func playCurrentPlayer() -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
			if let currentPlayer = self.currentPlayer {
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
    
    func playCurrentPlayer(with metadata: String, and url: String) -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
			if let currentPlayer = self.currentPlayer {
				let _ = currentPlayer.setMediaSourceToURL(url, metaData: metadata, autoPlay: true, andPlayInBackground: false).continue({ task -> Any? in
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
    
    func pauseCurrentPlayer() -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
			if let currentPlayer = self.currentPlayer {
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
    
    func setCurrentPlayer(Position position: Int64) -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
			if let currentPlayer = self.currentPlayer {
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
    
    func stopCurrentPlayer() -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
			if let currentPlayer = self.currentPlayer {
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
    func updateCurrentPlayerData(with status: MediaPlayerStatus, and position: Int64) -> Single<CurrentPlayerData?> {
		return Single.create(subscribe: { single -> Disposable in
			if let _ = self.currentPlayer {
				var currentPlayerData = CurrentPlayerData(status: status)
				
				let state = status.state()
				switch state.rawValue {
					case 2: // ReadyToPlay
						self.getDurationOfCurrentPlayer()
							.subscribe(onSuccess: { duration in
								currentPlayerData.duration = duration
								// TODO: is this necessary anymore?
								single(.success(currentPlayerData))
							}, onError: { error in
								single(.error(error))
							}).disposed(by: self.disposeBag)
					case 3, 4, 5: // Playing, Paused, Seeking
						currentPlayerData.position = position
						single(.success(currentPlayerData))
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
    func connect(to player: RemoteMediaPlayer) -> Single<CurrentPlayerData?> {
		return Single.create(subscribe: { single -> Disposable in
			if self.currentPlayer == nil {
				self.currentPlayer = player
				
				let _ = player.add(self).continue({ task -> Any? in
					DispatchQueue.main.async {
						if let error = task.error {
							single(.error(error))
						} else {
							self.getCurrentPlayerData()
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
				if let currentPlayer = self.currentPlayer,
					currentPlayer !== player {
					currentPlayer.remove(self).continue({ task -> Any? in
						DispatchQueue.main.async {
							if let error = task.error {
								single(.error(error))
							} else {
								self.currentPlayer = player
								
								let _ = player.add(self).continue({ task -> Any? in
									DispatchQueue.main.async {
										if let error = task.error {
											single(.error(error))
										} else {
											self.getCurrentPlayerData()
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
    
    func disconnect(from player: RemoteMediaPlayer?) -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
			if let player = player {
				let _ = player.remove(self).continue({ task -> Any? in
					DispatchQueue.main.async {
						if let error = task.error {
							completable(.error(error))
						} else {
							if let currentPlayer = self.currentPlayer, currentPlayer === player {
								self.currentPlayer = nil
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
    
    func disconnectFromCurrentPlayer() -> Completable {
        return disconnect(from: currentPlayer)
    }
}

extension PlayerService: MediaPlayerStatusListener {
    func onStatusChange(_ status: MediaPlayerStatus!, positionChangedTo position: Int64) {
        currentPlayerStatus = status
        
        updateCurrentPlayerData(with: status, and: position)
			.subscribe(onSuccess: { _ in
			}) { _ in
			}.disposed(by: disposeBag)
    }
}

extension PlayerService {
    private func getDurationOfCurrentPlayer() -> Single<Int?> {
        return Single.create(subscribe: { single -> Disposable in
            if let currentPlayer = self.currentPlayer {
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
    
    private func getPositionOfCurrentPlayer() -> Single<Int64?> {
        return Single.create(subscribe: { single -> Disposable in
            if let currentPlayer = self.currentPlayer {
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
    
    private func getCurrentPlayerData() -> Single<CurrentPlayerData?> {
        return Single.create(subscribe: { single -> Disposable in
            if let currentPlayer = self.currentPlayer {
                let _ = currentPlayer.getStatus().continue({ task -> Any? in
                    DispatchQueue.main.async {
                        if let error = task.error {
                            single(.error(error))
                        } else {
                            if let status = task.result as? MediaPlayerStatus {
                                let statusRawValue = status.state().rawValue
                                
                                var currentPlayerData = CurrentPlayerData(status: status)
                                
                                if statusRawValue != 7 && statusRawValue != 0 && statusRawValue != 6 {
                                    self.getDurationOfCurrentPlayer()
                                        .subscribe(onSuccess: { duration in
                                            self.getPositionOfCurrentPlayer()
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
