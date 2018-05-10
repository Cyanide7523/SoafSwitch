#
# Be sure to run `pod lib lint SoafSwitch.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SoafSwitch'
  s.version          = '0.1.1'
  s.summary          = 'SoafSwitch, A super-duper way of making designed switch.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SoafSwitch is a replacement of UISwitch, with fully customizable appearance setting.
                       DESC

  s.homepage         = 'https://github.com/Cyanide7523/SoafSwitch'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Cyanide7523' => 'ffasang123@icloud.com' }
  s.source           = { :git => 'https://github.com/Cyanide7523/SoafSwitch.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.swift_version = '4.0'

  s.source_files = 'SoafSwitch/Classes/**/*'

  # s.resource_bundles = {
  #   'SoafSwitch' => ['SoafSwitch/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
