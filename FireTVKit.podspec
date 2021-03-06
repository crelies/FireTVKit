#
# Be sure to run `pod lib lint FireTVKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FireTVKit'
  s.version          = '1.0.1'
  s.summary          = 'Discovering your FireTV and controlling the built-in media player is now easy and reactive.'

  s.description      = <<-DESC
  The Amazon Fling SDK lacks a ready to use view controller for discovering FireTVs and controlling the built-in receiver app (media player). That's why I created FireTVKit. It offers a themable view controller for discovering FireTVs in your local network. All the necessary magic happens under the hood. In addition the FireTVKit brings a themable view controller for controlling the built-in media player of a FireTV. Even there all the magic happens under the hood. Thanks to the protocol oriented approach you can easily create your own discovery and player view. If you want to be completely free just use the FireTVManager to do the discovery and get the FireTVs. Then show the FireTVs to your users the way you want it.
  
  The implementation of the `FireTVPlayer` and the `FireTVSelection` follows the `VIPER` architecture pattern. Make yourself comfortable with `VIPER` first if you want to implement a custom view.
                       DESC

  s.homepage         = 'https://github.com/crelies/FireTVKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Christian Elies' => 'chris.elies13@gmail.com' }
  s.source           = { :git => 'https://github.com/crelies/FireTVKit.git', :tag => s.version.to_s }

  s.cocoapods_version = '>= 1.4'
  s.swift_version = '4.0'
  s.ios.deployment_target = '9.0'

  s.source_files = 'FireTVKit/Classes/**/*.swift'
  s.resource_bundle = {
      'FireTVKit' => 'FireTVKit/**/*{.storyboard,.xcassets}'
  }

  s.frameworks = 'UIKit'
  
  s.dependency 'AmazonFling', '1.3.5'
  s.dependency 'ReachabilitySwift', '~> 4.3'
  s.dependency 'RxSwift', '~> 4.5'
  s.dependency 'RxCocoa', '~> 4.5'
  
  # https://github.com/CocoaPods/CocoaPods/issues/2926#issuecomment-136766631
  s.pod_target_xcconfig = {
      'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/AmazonFling',
      'OTHER_LDFLAGS'          => '$(inherited) -undefined dynamic_lookup',
      'ENABLE_BITCODE'         => 'NO'
  }
end
