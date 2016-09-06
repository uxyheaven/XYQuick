#
# Be sure to run `pod lib lint XYQuick.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = "XYQuick"
s.version          = "0.9.6"
s.summary          = "A quick develop utility on iOS."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
s.description      = <<-DESC
A quick develop utility on iOS...
DESC

s.homepage         = "https://github.com/uxyheaven"
# s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
s.license          = 'MIT'
s.author           = { "xingyao095" => "xingyao095@pingan.com.cn" }
s.source           = { :git => "https://github.com/uxyheaven/XYQuick.git", :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.platform     = :ios, '7.0'
s.requires_arc = true

#s.source_files = 'Pod/Classes/**/*'
s.public_header_files = 'Pod/Classes/XYQuick.h'
s.source_files = 'Pod/Classes/XYQuick.{h,m}'

s.subspec 'predefine' do |ss|
ss.source_files  = 'Pod/Classes/predefine/*.{h,m}'
ss.public_header_files = 'Pod/Classes/predefine/**/*.h'
end

s.subspec 'core' do |ss|
ss.source_files  = 'Pod/Classes/core/**/*'
ss.public_header_files = 'Pod/Classes/core/**/*.h'
ss.dependency 'XYQuick/predefine'
end

s.subspec 'ui' do |ss|
ss.source_files  = 'Pod/Classes/ui/**/*'
ss.public_header_files = 'Pod/Classes/ui/**/*.h'
ss.dependency 'XYQuick/predefine'
ss.dependency 'XYQuick/core'
end

s.subspec 'event' do |ss|
ss.source_files  = 'Pod/Classes/event/**/*'
ss.public_header_files = 'Pod/Classes/event/**/*.h'
ss.dependency 'XYQuick/predefine'
ss.dependency 'XYQuick/core'
ss.dependency 'XYQuick/ui'
end
end
