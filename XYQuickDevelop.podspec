Pod::Spec.new do |s|  
  s.name             = "XYQuickDevlop"  
  s.version          = "1.0.0"  
  s.summary          = "A quick devlop utility on iOS."  
  s.homepage         = "https://github.com/uxyheaven"  
  s.license          = 'MIT'  
  s.author           = { "uxyheaven" => "uxyheaven@163.com" }  
  s.source           = { :git => "https://github.com/uxyheaven/XYQuickDevelop.git", :tag => s.version.to_s }  
  
  s.platform     = :ios, '7.0'  
  # s.ios.deployment_target = '7.0'  
  # s.osx.deployment_target = '10.7'  
  s.requires_arc = true  
  
  s.source_files = 'XYQuickDevelop/*'  
  # s.resources = 'Assets'  
  
  # s.ios.exclude_files = 'Classes/osx'  
  # s.osx.exclude_files = 'Classes/ios'  
  # s.public_header_files = 'Classes/**/*.h'  
  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'  
  
end