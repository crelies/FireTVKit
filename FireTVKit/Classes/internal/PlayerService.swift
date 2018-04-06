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
					.subscribe(onCompleted: { [weak self] in
						// connect to new player
						self?.connect(toPlayer: newValue)
							.subscribe(onSuccess: { playerData in
                                if let playerData = playerData {
                                    self?.playerDataVariable.value = playerData
                                }
							}).disposed(by: self!.disposeBag)
					}) { [weak self] _ in
						// connect to new player
						self?.connect(toPlayer: newValue)
							.subscribe(onSuccess: { playerData in
                                if let playerData = playerData {
                                   self?.playerDataVariable.value = playerData
                                }
							}).disposed(by: self!.disposeBag)
					}.disposed(by: disposeBag)
			}
        }
    }
	
	var playerData: Observable<PlayerData?> {
		return playerDataVariable.asObservable()
	}
    
    private var playerDataVariable: Variable<PlayerData?>
	private let disposeBag: DisposeBag
	
    init(withPlayer player: RemoteMediaPlayer) {
        self.player = player
        playerDataVariable = Variable<PlayerData?>(nil)
        disposeBag = DisposeBag()
        
        super.init()
        
        connect(toPlayer: player)
            .subscribe(onSuccess: { [weak self] playerData in
                if let playerData = playerData {
                    self?.playerDataVariable.value = playerData
                }
            }).disposed(by: disposeBag)
        
        print("PlayerService initialized")
    }
    
    deinit {
        print("PlayerService deinitialized")
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
    
    func setPosition(position: Int64, type: SeekType) -> Completable {
		return Completable.create(subscribe: { completable -> Disposable in
            let _ = self.player.seek(toPosition: position, andMode: type).continue(with: BFExecutor.mainThread(), with: { task -> Any? in
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
	func getPlayerData() -> Single<PlayerData> {
		return Single.create(subscribe: { single -> Disposable in
			
			let statusTask: BFTask<AnyObject> = self.player.getStatus()
			let positionTask: BFTask<AnyObject> = self.player.getPosition()
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
			
			return Disposables.create()
		})
	}
	
	func getDuration() -> Single<Int> {
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
	
	func getPosition() -> Single<Int64> {
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
    
    func disconnect() {
        disconnect(fromPlayer: player)
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension PlayerService: MediaPlayerStatusListener {
    func onStatusChange(_ status: MediaPlayerStatus!, positionChangedTo position: Int64) {
		let playerData = PlayerData(status: status, position: position)
		self.playerDataVariable.value = playerData
		
		if playerData.status == .readyToPlay {
			self.getDuration()
				.subscribe(onSuccess: { duration in
					let playerData = PlayerData(duration: duration)
					self.playerDataVariable.value = playerData
				}).disposed(by: disposeBag)
		}
    }
}

extension PlayerService {
    // MARK: - player connection
    private func connect(toPlayer player: RemoteMediaPlayer) -> Single<PlayerData?> {
        return Single.create(subscribe: { single -> Disposable in
            let disposable = Disposables.create()
            
            _ = player.add(self).continue(with: BFExecutor.mainThread(), with: { task -> Any? in
                if let error = task.error {
                    single(.error(error))
                } else {
                    // TODO: this should be not necessary because of the status updates
//                    disposable = self.getPlayerData()
//                        .subscribe(onSuccess: { currentPlayerData in
//                            single(.success(currentPlayerData))
//                        }, onError: { error in
//                            single(.error(error))
//                        })
                    single(.success(nil))
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
}
