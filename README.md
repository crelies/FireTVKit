# FireTVKit

Discovering your FireTV and controlling the built-in media player is now easy

[![Version](https://img.shields.io/cocoapods/v/FireTVKit.svg?longCache=true&style=flat-square)](http://cocoapods.org/pods/FireTVKit)
[![Swift4](https://img.shields.io/badge/swift4-compatible-orange.svg?longCache=true&style=flat-square)](https://developer.apple.com/swift)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg?longCache=true&style=flat-square)](https://www.apple.com/de/ios)
[![Carthage](https://img.shields.io/badge/carthage-compatible-green.svg?longCache=true&style=flat-square)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg?longCache=true&style=flat-square)](https://en.wikipedia.org/wiki/MIT_License)

## Features ##

| | Feature |
| --- | --- |
| 🔎 | Themable view controller for FireTV discovery and selection |
| 🎮 | Themable view controller for controlling the built-in media player of a FireTV |
| 🐶 | FireTVManager to do the discovery and get the list of available FireTVs |
| ✅ | Unit tested |
| 🗽 | Extendable API |
| 🚀 | Written in Swift |

## How to use

Coming soon ...

1. Create and present a `FireTVSelectionViewController`

```swift
final class ViewController: UIViewController {
    override func viewDidLoad() {

    }
}
```

2. Create and present a `FireTVPlayerViewController`

```swift
```

3. Usage of the  `FireTVManager`

```swift
```

```swift
import AmazonFling
import FireTVKit
import RxSwift
import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var foundDevicesLabel: UILabel!

    private let disposeBag: DisposeBag = DisposeBag()
    private var fireTVManager: FireTVManager?
    private var devices: [RemoteMediaPlayer] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        fireTVManager = FireTVManager()

        fireTVManager?.devices
        .subscribe(onNext: { devices in
            DispatchQueue.main.async {
                if let devices = devices {
                    self.foundDevicesLabel.text = devices.flatMap { $0.name() }.joined(separator: "\n")

                    self.devices = devices
                } else {
                    self.foundDevicesLabel.text = "No devices found"
                }
            }
        }).disposed(by: disposeBag)

        if let reachabilityService = ServiceFactory.makeReachabilityService() {
            do {
                reachabilityService.reachabilityObservable
                .subscribe(onNext: { reachability in
                    if reachability.connection == .wifi {
                        self.fireTVManager?.startDiscovery(forPlayerID: "amzn.thin.pl")
                    } else {
                        self.fireTVManager?.stopDiscovery()
                    }
                }).disposed(by: disposeBag)

                try reachabilityService.startListening()
            } catch {

            }
        }
    }

    @IBAction func didPressStartDiscoveryButton(_ sender: UIButton) {
        fireTVManager?.startDiscovery(forPlayerID: "amzn.thin.pl")
    }

    @IBAction func didPressStopDiscoveryButton(_ sender: UIButton) {
        fireTVManager?.stopDiscovery()
    }

    @IBAction func didPressPlayTestVideoButton(_ sender: UIButton) {
        if let firstDevice = devices.first {
            let playerService = ServiceFactory.makePlayerService(withPlayer: firstDevice)
            
            _ = playerService.play(withMetadata: "Barcelona", url: "https://...")
            .subscribe(onCompleted: {
                print("success")
            }, onError: { error in
                print(error)
            })
        }
    }

    @IBAction func didPressStopPlaybackButton(_ sender: UIButton) {
        if let firstDevice = devices.first {
            let playerService = ServiceFactory.makePlayerService(withPlayer: firstDevice)
            
            _ = playerService.stop()
            .subscribe(onCompleted: {
                print("success")
            }, onError: { error in
                print(error)
            })
        }
    }
}
```

## Example

Coming soon ...

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Customize

Coming soon ...

## Requirements

Currently there is only a reactive implementation. That's why you need `RxSwift`.
At the moment the `AmazonFling-SDK` doesn't support bitcode. So you need to disable it.

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
