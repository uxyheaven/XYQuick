Pod::Spec.new do |s|  
  version            = "0.5.6"
  s.name             = "XYQuick"  
  s.version          = version  
  s.summary          = "A quick develop utility on iOS."  
  s.homepage         = "https://github.com/uxyheaven"  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }  
  s.author           = { "uxyheaven" => "uxyheaven@163.com" }  
  s.platform         = :ios, '7.0'
  s.source           = { :git => "https://github.com/uxyheaven/XYQuickDevelop.git", :tag => version } 
  #s.source_files     = 'XYQuick/*', 'XYQuick/**/*'
  s.requires_arc     = true

  s.subspec 'core' do |ss|
    core.source_files  = 'XYQuick/core/**/*'
  end

  s.subspec 'debug' do |ss|
    core.source_files  = 'XYQuick/debug/**/*'
  end

  s.subspec 'event' do |ss|
    core.source_files  = 'XYQuick/event/**/*'
  end

  s.subspec 'ui' do |ss|
    core.source_files  = 'XYQuick/ui/**/*'
  end

  s.subspec 'header' do |ss|
    core.source_files  = 'XYQuick/*'
  end
end