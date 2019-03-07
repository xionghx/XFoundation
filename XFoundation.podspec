#
# Be sure to run `pod lib lint XFoundation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XFoundation'
  s.version          = '0.1.2'
  s.summary          = 'A short description of XFoundation.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/xionghx/XFoundation'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xionghx' => 'xionghuanxin@hotmail.com' }
  s.source           = { :git => 'https://github.com/xionghx/XFoundation.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'XFoundation/Classes/**/*'
  
  # s.resource_bundles = {
  #   'XFoundation' => ['XFoundation/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'MJRefresh', '~> 3.1.15.7'
  s.dependency 'MBProgressHUD', '~> 1.1.0'
  s.dependency 'Moya', '~> 11.0.2'
  s.dependency 'ObjectMapper', '~> 3.3.0'
  s.dependency 'CryptoSwift', '~> 0.11.0'
  s.dependency 'SnapKit', '~> 4.0.1'
  s.dependency 'Kingfisher', '~> 4.9.0'
  s.dependency 'SwiftyUserDefaults', '~> 3.0.1'
  s.dependency 'JXPhotoBrowser', '1.5.1'
  s.dependency 'IQKeyboardManagerSwift', '~> 6.1.1'
  s.dependency 'DeviceKit', '~> 1.8.1'
  
  s.dependency 'TZImagePickerController', '~> 3.0.8'
  
  
  s.dependency 'SwiftyBeaver', '~> 1.6.1'
  
  
  s.dependency 'RxSwift', '~> 4.3.1'
  s.dependency 'RxCocoa', '~> 4.3.1'
  s.dependency 'NSObject+Rx', '~> 4.4.1'
  s.dependency 'RxOptional', '~> 3.5.0'
end
