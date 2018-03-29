# AmazonFling

Easily integrate the *Amazon Fling SDK* to discover and control your FireTV in your app

[![Version](https://img.shields.io/cocoapods/v/AmazonFling.svg?longCache=true&style=flat-square)](http://cocoapods.org/pods/AmazonFling)
[![Swift4](https://img.shields.io/badge/swift4-compatible-orange.svg?longCache=true&style=flat-square)](https://developer.apple.com/swift)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg?longCache=true&style=flat-square)](https://www.apple.com/de/ios)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg?longCache=true&style=flat-square)](https://en.wikipedia.org/wiki/MIT_License)

## Example

Import *AmazonFling* and start using the SDK:

```swift
import AmazonFling
import UIKit

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let discoveryController = DiscoveryController()
        discoveryController.searchPlayer(withId: "amzn.thin.pl", andListener: self)
    }
}

extension ViewController: DiscoveryListener {
    func deviceDiscovered(_ device: RemoteMediaPlayer!) {
        print("Discovered device [\(device)]")
    }

    func deviceLost(_ device: RemoteMediaPlayer!) {
        print("Lost device [\(device)]")
    }

    func discoveryFailure() {
        print("Discovery failed")
    }
}
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Just install the Pod ;)

## Installation

*AmazonFling* is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AmazonFling'
```

## Author

Christian Elies, chris.elies13@gmail.com

## License

*AmazonFling* is available under the MIT license. See the LICENSE file for more info.
