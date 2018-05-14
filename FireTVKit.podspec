#
# Be sure to run `pod lib lint FireTVKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FireTVKit'
  s.version          = '0.1.0'
  s.summary          = 'Discovering and controlling your FireTV is now easy.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/crelies/FireTVKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Christian Elies' => 'chris.elies13@gmail.com' }
  s.source           = { :git => 'https://github.com/crelies/FireTVKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'FireTVKit/Classes/**/*.swift'
  s.resource_bundle = {
      'FireTVKit' => 'FireTVKit/**/*{.storyboard,.xcassets}'
  }

  s.frameworks = 'UIKit'
  
  s.dependency 'AmazonFling', '~> 1.3.1'
  s.dependency 'ReachabilitySwift', '~> 4.1.0'
  s.dependency 'RxSwift', '~> 4.0.0'
  s.dependency 'RxCocoa', '~> 4.0.0'
  
  # https://github.com/CocoaPods/CocoaPods/issues/2926#issuecomment-136766631
  s.pod_target_xcconfig = {
      'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/AmazonFling',
      'OTHER_LDFLAGS'          => '$(inherited) -undefined dynamic_lookup',
      'ENABLE_BITCODE'         => 'NO'
  }
end
