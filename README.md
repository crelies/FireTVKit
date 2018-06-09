# FireTVKit

Discovering your FireTV and controlling the built-in media player is now easy and reactive

[![Version](https://img.shields.io/cocoapods/v/FireTVKit.svg?longCache=true&style=flat-square)](http://cocoapods.org/pods/FireTVKit)
[![Swift4](https://img.shields.io/badge/swift4-compatible-orange.svg?longCache=true&style=flat-square)](https://developer.apple.com/swift)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg?longCache=true&style=flat-square)](https://www.apple.com/de/ios)
[![Carthage](https://img.shields.io/badge/carthage-compatible-green.svg?longCache=true&style=flat-square)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg?longCache=true&style=flat-square)](https://en.wikipedia.org/wiki/MIT_License)

The Amazon Fling SDK lacks a ready to use view controller for discovering FireTVs and controlling the built in receiver (media player). That's why I created FireTVKit. It offers a themable view controller for discovering FireTVs in your network. All the necessary magic happens under the hood. In addition the FireTVKit brings a themable view controller for controlling the built in media player of a FireTV. Also there all the magic happens under the hood. Thanks to the protocol oriented approach you can easily create your own discovery and player view. If you want to be completely free just use the FireTVManager to do the discovery and get the FireTVs.

## Features ##

| | Feature |
| --- | --- |
| 🔎 | Themable view controller for FireTV discovery and selection |
| 🎮 | Themable view controller for controlling the built-in media player of a FireTV |
| 🐶 | FireTVManager to do the discovery and get the list of available FireTVs |
| 📡 | Built-in wifi connection validation |
| ✅ | Unit tested |
| 🗽 | Extendable API |
| 🚀 | Written in Swift |

## Examples ##

**1. FireTV Player Selection with Dark Theme**

![FireTV Player Selection with Dark Theme](https://github.com/crelies/FireTVKit/blob/develop/docs/dark%20mock%20player%20selection.gif)

**2. FireTV Player Selection in no devices state**

![FireTV Player Selection in no devices state](https://github.com/crelies/FireTVKit/blob/develop/docs/dark%20mock%20player%20selection%20in%20no%20devices%20state.gif)

**3. FireTV Player Selection in no wifi state**

![FireTV Player Selection in no wifi state](https://github.com/crelies/FireTVKit/blob/develop/docs/dark%20mock%20player%20selection%20in%20no%20wifi%20state.gif)

**4. FireTV Player with Dark Theme**

![FireTV Player with Dark Theme](https://github.com/crelies/FireTVKit/blob/develop/docs/dark%20mock%20player.gif)

**5. FireTV Player with Light Theme**

![FireTV Player with Light Theme](https://github.com/crelies/FireTVKit/blob/develop/docs/light%20mock%20player.gif)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## How to use

1. Create and present a `FireTVSelectionViewController`

```swift
import AmazonFling
import FireTVKit
import UIKit

final class ViewController: UIViewController {
	private lazy var SAMPLE_VIDEO_METADATA: Metadata = {
		var metadata = Metadata(type: .video)
		metadata.title = "Testvideo"
		metadata.description = "A video for test purposes"
		metadata.noreplay = true
		return metadata
	}()
	private let SAMPLE_VIDEO_URL = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
	private lazy var SAMPLE_VIDEO: URL? = {
		guard let url = URL(string: SAMPLE_VIDEO_URL) else {
			return nil
		}

		return url
	}()
	private var selectedPlayer: RemoteMediaPlayer?

    override func viewDidLoad() {
    	super.viewDidLoad()
    	
    	guard let url = SAMPLE_VIDEO else {
    		return
    	}
    	
    	let media = FireTVMedia(metadata: SAMPLE_VIDEO_METADATA, url: url)
    	let theme = FireTVSelectionDarkTheme()
    	let playerId = "amzn.thin.pl"
    	let fireTVSelectionVC = try FireTVSelectionWireframe.makeViewController(theme: theme, playerId: playerId, media: media, delegate: self)
    	present(fireTVSelectionVC, animated: true)
    }
}

extension ViewController: FireTVSelectionDelegateProtocol {
	func didSelectPlayer(_ fireTVSelectionViewController: FireTVSelectionViewController, player: RemoteMediaPlayer) {
		fireTVSelectionViewController.dismiss(animated: true, completion: nil)

		selectedPlayer = player
	}

	func didPressCloseButton(_ fireTVSelectionViewController: FireTVSelectionViewController) {
		fireTVSelectionViewController.dismiss(animated: true, completion: nil)
	}
}
```

2. Create and present a `FireTVPlayerViewController`

```swift
import AmazonFling
import FireTVKit
import UIKit

final class ViewController: UIViewController {
	private var selectedPlayer: RemoteMediaPlayer?

    override func viewDidLoad() {
    	super.viewDidLoad()
    	
    	guard let selectedPlayer = selectedPlayer else {
    		return
    	}
    	
    	let theme = FireTVPlayerDarkTheme()
    	let fireTVPlayerVC = try FireTVPlayerWireframe.makeViewController(forPlayer: player, theme: theme, delegate: self)
		present(fireTVPlayerVC, animated: true)
    }
}

extension ViewController: FireTVPlayerDelegateProtocol {
	func didPressCloseButton(_ fireTVPlayerViewController: FireTVPlayerViewController) {
		fireTVPlayerViewController.dismiss(animated: true, completion: nil)
	}
}
```

## FireTVManager

In the following code example you will see how to discover and get the available FireTVs using a `FireTVManager` instance. You can control the built-in media player of a FireTV using a `PlayerService` instance.

```swift
import AmazonFling
import FireTVKit
import RxSwift
import UIKit

final class FireTVManagerExampleViewController: UIViewController {
    private var fireTVManager: FireTVManager?
    private var disposeBag: DisposeBag?
    @IBOutlet private weak var firstPlayerLabel: UILabel!
    
    deinit {
        print("FireTVManagerExampleViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let disposeBag = DisposeBag()
        self.disposeBag = disposeBag

        do {
            fireTVManager = try FireTVManager()

            try fireTVManager?.startDiscovery(forPlayerID: "amzn.thin.pl")

            fireTVManager?.devicesObservable
                .subscribe(onNext: { [weak self] player in
                    if !player.isEmpty {
                        self?.firstPlayerLabel?.text = player.first?.name()
                    } else {
                        self?.firstPlayerLabel.text = "No player found"
                    }
                }, onError: { error in
                    print(error)
                }).disposed(by: disposeBag)
        } catch {
            print(error)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fireTVManager?.stopDiscovery()
    }
    
    @IBAction private func didPressCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
```

## Customize

1. You can use the `FireTVSelectionViewProtocol` to create your own view for the fire tv selection.
2. Use the `FireTVPlayerViewProtocol` to create your custom player view.
3. With the `FireTVSelectionThemeProtocol` and the `FireTVPlayerThemeProtocol` you can build custom themes for the themable selection and player view controller.

## Requirements

1. Currently there is only a reactive implementation. That's why you need `RxSwift`.
2. Deployment target of your App is >= iOS 9.0 .
3. At the moment Bitcode is not supported. I hope that I will make progress in the future.

## Installation

*FireTVKit* is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FireTVKit'
```

## Author

Christian Elies, chris.elies13@gmail.com

## License

*FireTVKit* is available under the MIT license. See the LICENSE file for more info.
