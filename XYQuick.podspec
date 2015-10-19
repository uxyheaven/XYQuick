Pod::Spec.new do |s|  
  version            = "0.8.6"
  s.name             = "XYQuick"  
  s.version          = version  
  s.summary          = "A quick develop utility on iOS."  
  s.homepage         = "https://github.com/uxyheaven"  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }  
  s.author           = { "uxyheaven" => "uxyheaven@163.com" }  
  s.platform         = :ios, '7.0'
  s.source           = { :git => "https://github.com/uxyheaven/XYQuick.git", :tag => version } 
  #s.source_files     = 'XYQuick/*'
  s.requires_arc     = true

  s.subspec 'header' do |ss|
    ss.source_files  = 'XYQuick/*'
  end

  s.subspec 'core' do |ss|
    ss.source_files  = 'XYQuick/core/**/*'
    ss.dependency 'XYQuick/header'
  end

  s.subspec 'ui' do |ss|
    ss.source_files  = 'XYQuick/ui/**/*'
    ss.dependency 'XYQuick/header'
    ss.dependency 'XYQuick/core'
  end

    s.subspec 'event' do |ss|
    ss.source_files  = 'XYQuick/event/**/*'
    ss.dependency 'XYQuick/header'
    ss.dependency 'XYQuick/core'
    ss.dependency 'XYQuick/ui'
  end

end