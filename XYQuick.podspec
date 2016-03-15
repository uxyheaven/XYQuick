Pod::Spec.new do |s|  
  version            = "0.8.14"
  s.name             = "XYQuick"  
  s.version          = version  
  s.summary          = "A quick develop utility on iOS."  
  s.homepage         = "https://github.com/uxyheaven"  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }  
  s.author           = { "uxyheaven" => "uxyheaven@163.com" }  
  s.platform         = :ios, '7.0'
  s.source           = { :git => "https://github.com/uxyheaven/XYQuick.git", :tag => version } 
  s.requires_arc     = true

  s.public_header_files = 'XYQuick/XYQuick.h'
  s.source_files = 'XYQuick/XYQuick.h'

  s.subspec 'predefine' do |ss|
    ss.source_files  = 'XYQuick/predefine/**/*'
    ss.public_header_files = 'XYQuick/predefine/**/*.h'
  end

  s.subspec 'core' do |ss|
    ss.source_files  = 'XYQuick/core/**/*'
    ss.public_header_files = 'XYQuick/core/**/*.h'
    ss.dependency 'XYQuick/predefine'
  end

  s.subspec 'ui' do |ss|
    ss.source_files  = 'XYQuick/ui/**/*'
    ss.public_header_files = 'XYQuick/ui/**/*.h'
    ss.dependency 'XYQuick/predefine'
    ss.dependency 'XYQuick/core'
  end

    s.subspec 'event' do |ss|
    ss.source_files  = 'XYQuick/event/**/*'
    ss.public_header_files = 'XYQuick/event/**/*.h'
    ss.dependency 'XYQuick/predefine'
    ss.dependency 'XYQuick/core'
    ss.dependency 'XYQuick/ui'
  end

end