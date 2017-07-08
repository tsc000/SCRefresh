
Pod::Spec.new do |s|

  s.name         = "SCRefresh"
  s.version      = "0.2.3"
  s.summary      = " A custom refresh control."
  s.description  = " A custom refresh control ."
  s.homepage     = "https://github.com/tsc000"
  s.license      = "MIT"
  s.author             = { "童世超" => "787753577@qq.com" }
  s.social_media_url   = "http://www.jianshu.com/u/e7eb6a8ef66c"
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/tsc000/SCRefresh.git", :tag => "#{s.version}" }
  s.source_files  = "Refresh/Refresh/Source/**/*.{h,m}"
  s.public_header_files = "Refresh/Refresh/Source/Base/*.h"
  s.resource  = "Refresh/Refresh/Source/Base/SCRefresh.bundle"
  s.framework  = "UIKit"
  s.requires_arc = true

end
