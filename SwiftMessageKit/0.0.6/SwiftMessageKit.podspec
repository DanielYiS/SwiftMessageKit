#
# Be sure to run `pod lib lint SwiftMessageKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#
# 1. new code update github
# 2. local not code : pod repo add SwiftMessageKit  https://github.com/cdzhangshuangyu/SwiftMessageKit.git
#    local uodate code: cd ~/.cocoapods/repos/SwiftMessageKit. Then execute: pod repo update SwiftMessageKit
# 3. pod repo push SwiftMessageKit SwiftMessageKit.podspec --allow-warnings --sources='https://github.com/CocoaPods/Specs.git'
# 4. pod trunk push SwiftMessageKit.podspec --allow-warnings
# 5. pod install or pod update on you project execute

Pod::Spec.new do |s|
  s.name             = 'SwiftMessageKit'
  s.version          = '0.0.6'
  s.summary          = 'SwiftMessageKit'
  s.module_name      = 'SwiftMessageKit'

  s.homepage         = 'https://github.com/cdzhangshuangyu/SwiftMessageKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cdzhangshuangyu' => 'cdzhangshuangyu@163.com' }
  s.source           = { :git => 'https://github.com/cdzhangshuangyu/SwiftMessageKit.git', :tag => s.version.to_s }
  
  s.platform              = :ios, '10.0'
  s.swift_versions        = "5"
  s.ios.deployment_target = '10.0'
  s.pod_target_xcconfig   = { 'SWIFT_VERSION' => '5.0' }
  
  s.frameworks    = 'UIKit'
  s.libraries     = 'z', 'sqlite3', 'c++'
  s.source_files  = 'SwiftMessageKit/**/*.{swift,h,m}'
  s.resources     = ['SwiftMessageKit/**/*.strings']
  
  s.dependency 'Starscream'
  s.dependency 'SwiftBasicKit'
end
