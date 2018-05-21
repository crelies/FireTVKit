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

protocol PlayerServiceProvider {
    var playerService: PlayerServiceProtocol { get }
}

final class PlayerService: NSObject, PlayerServiceProtocol {
    var player: RemoteMediaPlayer?
	
	var playerData: Observable<PlayerData?> {
		return playerDataVariable.asObservable()
	}
    
    private var playerDataVariable: Variable<PlayerData?>
	private let disposeBag: DisposeBag
	
    init(withPlayer player: RemoteMediaPlayer?) {
        self.player = player
        playerDataVariable = Variable<PlayerData?>(nil)
        disposeBag = DisposeBag()
        
        super.init()
        
        // TODO: remove me
        print("PlayerService initialized")
    }
    
    // TODO: remove me
    deinit {
        print("PlayerService deinitialized")
    }
    
    func connectToPlayer(_ newPlayer: RemoteMediaPlayer) -> Completable {
        return Completable.create { completable -> Disposable in
            var disposable = Disposables.create()
            
            if let currentPlayer = self.player {
                if currentPlayer.uniqueIdentifier() != newPlayer.uniqueIdentifier() {
                    // disconnect from current player
                    let disconnectFromCurrentPlayer = self.disconnect(fromPlayer: currentPlayer)
                    let connectToNewPlayer = self.connect(toPlayer: newPlayer)
                    
                    disposable = Completable.merge([disconnectFromCurrentPlayer, connectToNewPlayer])
                        .subscribe(onCompleted: {
                            self.player = newPlayer
                            completable(.completed)
                        }, onError: { error in
                            // TODO:
                            print("connectToPlayer: \(error)")
                            completable(.error(error))
                        })
                }
            } else {
                disposable = self.connect(toPlayer: newPlayer)
                    .subscribe(onCompleted: {
                        self.player = newPlayer
                        completable(.completed)
                    }, onError: { error in
                        // TODO:
                        print("connectToPlayer: \(error)")
                        completable(.error(error))
                    })
            }
            
            return disposable
        }
    }
    
    // MARK: - player control
    func play() -> Completable {
		return Completable.create { completable -> Disposable in
            let disposable = Disposables.create()
            
            guard let currentPlayer = self.player else {
                completable(.error(PlayerServiceError.noPlayer))
                return disposable
            }
            
            let _ = currentPlayer.play().continue(with: BFExecutor.mainThread(), with: { task -> Any? in
                if let error = task.error {
                    completable(.error(error))
                } else {
                    completable(.completed)
                }
                
                return nil
            })
			
			return disposable
		}
    }
	
    func play(withMetadata metadata: Metadata, url: String) -> Completable {
		return Completable.create { completable -> Disposable in
            let disposable = Disposables.create()
            
            guard let currentPlayer = self.player else {
                completable(.error(PlayerServiceError.noPlayer))
                return disposable
            }
            
			do {
				let metadataData = try JSONEncoder().encode(metadata)
				
                if let metadataString = String(data: metadataData, encoding: .utf8) {
                    // The built-in media player receiver does not support autoplay and playInBg at this time. A custom media player is required to use these options.
                    let _ = currentPlayer.setMediaSourceToURL(url, metaData: metadataString, autoPlay: true, andPlayInBackground: false).continue(with: BFExecutor.mainThread(), with: { task -> Any? in
                        if let error = task.error {
                            completable(.error(error))
                        } else {
                            completable(.completed)
                        }
                        
                        return nil
                    })
                } else {
                    completable(.error(PlayerServiceError.couldNotCreateStringFromMetadata))
                    return disposable
                }
			} catch {
				completable(.error(error))
			}
			
			return disposable
		}
    }
    
    func pause() -> Completable {
		return Completable.create { completable -> Disposable in
            let disposable = Disposables.create()
            
            guard let currentPlayer = self.player else {
                completable(.error(PlayerServiceError.noPlayer))
                return disposable
            }
            
            let _ = currentPlayer.pause().continue(with: BFExecutor.mainThread(), with: { task -> Any? in
                if let error = task.error {
                    completable(.error(error))
                } else {
                    completable(.completed)
                }
                
                return nil
            })
			
			return disposable
		}
    }
    
    func setPosition(position: Int64, type: SeekType) -> Completable {
		return Completable.create { completable -> Disposable in
            let disposable = Disposables.create()
            
            guard let currentPlayer = self.player else {
                completable(.error(PlayerServiceError.noPlayer))
                return disposable
            }
            
            let _ = currentPlayer.seek(toPosition: position, andMode: type).continue(with: BFExecutor.mainThread(), with: { task -> Any? in
                if let error = task.error {
                    completable(.error(error))
                } else {
                    completable(.completed)
                }
                
                return nil
            })
			
			return disposable
		}
    }
    
    func stop() -> Completable {
		return Completable.create { completable -> Disposable in
            let disposable = Disposables.create()
            
            guard let currentPlayer = self.player else {
                completable(.error(PlayerServiceError.noPlayer))
                return disposable
            }
            
            let _ = currentPlayer.stop().continue(with: BFExecutor.mainThread(), with: { task -> Any? in
                if let error = task.error {
                    completable(.error(error))
                } else {
                    completable(.completed)
                }
                
                return nil
            })
			
			return disposable
		}
    }
	
	// MARK: - player data
    func getPlayerInfo() -> Single<MediaPlayerInfo> {
        return Single.create { single -> Disposable in
            let disposable = Disposables.create()
            
            guard let currentPlayer = self.player else {
                single(.error(PlayerServiceError.noPlayer))
                return disposable
            }
            
            let _ = currentPlayer.getMediaInfo().continue(with: BFExecutor.mainThread(), with: { task -> Any? in
                if let error = task.error {
                    single(.error(error))
                } else {
                    if let playerInfo = task.result as? MediaPlayerInfo {
                        single(.success(playerInfo))
                    } else {
                        single(.error(PlayerServiceError.couldNotCastTaskResultToMediaPlayerInfo))
                    }
                }
                
                return nil
            })
            
            return disposable
        }
    }
    
	func getPlayerData() -> Single<PlayerData> {
		return Single.create { single -> Disposable in
            let disposable = Disposables.create()
            
            guard let currentPlayer = self.player else {
                single(.error(PlayerServiceError.noPlayer))
                return disposable
            }
			
            let statusTask: BFTask<AnyObject> = currentPlayer.getStatus()
            let positionTask: BFTask<AnyObject> = currentPlayer.getPosition()
			let tasks = [statusTask, positionTask]
			
			BFTask<AnyObject>(forCompletionOfAllTasksWithResults: tasks).continue(with: BFExecutor.mainThread(), with: { taskResults -> Any? in
				if let results = taskResults.result as? [AnyObject], results.count > 1, let status = results[0] as? MediaPlayerStatus, let position = results[1] as? Int64 {
					let playerData = PlayerData(status: status, position: position)
					single(.success(playerData))
				} else {
					single(.error(PlayerServiceError.invalidTaskResult))
				}
				
				return nil
			})
			
			return disposable
		}
	}
	
	func getDuration() -> Single<Int64> {
		return Single.create { single -> Disposable in
            let disposable = Disposables.create()
            
            guard let currentPlayer = self.player else {
                single(.error(PlayerServiceError.noPlayer))
                return disposable
            }
            
            let _ = currentPlayer.getDuration().continue(with: BFExecutor.mainThread(), with: { task -> Any? in
				if let error = task.error {
					single(.error(error))
				} else {
					if let duration = task.result as? Int64 {
						single(.success(duration))
					} else {
						single(.error(PlayerServiceError.couldNotCastDurationToInt))
					}
				}
				
				return nil
			})
			
			return disposable
		}
	}
	
	func getPosition() -> Single<Int64> {
		return Single.create { single -> Disposable in
            let disposable = Disposables.create()
            
            guard let currentPlayer = self.player else {
                single(.error(PlayerServiceError.noPlayer))
                return disposable
            }
            
            let _ = currentPlayer.getPosition().continue(with: BFExecutor.mainThread(), with: { task -> Any? in
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
			
			return disposable
		}
	}
    
    func disconnect(fromPlayer oldPlayer: RemoteMediaPlayer) -> Completable {
        return Completable.create { completable -> Disposable in
            let disposable = Disposables.create()
            
            guard let currentPlayer = self.player, currentPlayer.uniqueIdentifier() == oldPlayer.uniqueIdentifier() else {
                completable(.error(PlayerServiceError.currentPlayerComparisonFailed))
                return disposable
            }
            
            _ = oldPlayer.remove(self).continue(with: BFExecutor.mainThread(), with: { task -> Any? in
                if let error = task.error {
                    completable(.error(error))
                } else {
                    completable(.completed)
                }
                
                return nil
            })
            
            return disposable
        }
    }
}

extension PlayerService: MediaPlayerStatusListener {
    func onStatusChange(_ status: MediaPlayerStatus!, positionChangedTo position: Int64) {
        print("onStatusChange")
        let playerData = PlayerData(status: status, position: position)
        playerDataVariable.value = playerData
    }
}

extension PlayerService {
    // MARK: - player connection
    private func connect(toPlayer newPlayer: RemoteMediaPlayer) -> Completable {
        return Completable.create { completable -> Disposable in
            let disposable = Disposables.create()
            
            _ = newPlayer.add(self).continue(with: BFExecutor.mainThread(), with: { task -> Any? in
                if let error = task.error {
                    completable(.error(error))
                } else {
                    completable(.completed)
                }
                
                return nil
            })
            
            return disposable
        }
    }
}
