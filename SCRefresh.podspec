
Pod::Spec.new do |s|

  s.name         = "SCRefresh"
  s.version      = "0.0.2"
  s.summary      = " A custom refresh control."
  s.description  = " A custom refresh control ."

  s.homepage     = "https://github.com/tsc000"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "童世超" => "787753577@qq.com" }
  # Or just: s.author    = "童世超"
  # s.authors            = { "童世超" => "787753577@qq.com" }
  s.social_media_url   = "http://www.jianshu.com/u/e7eb6a8ef66c"

  # s.platform     = :ios
  s.platform     = :ios, "8.0"

  #  When using multiple platforms
  s.ios.deployment_target = "8.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/tsc000/SCRefresh.git", :tag => "#{s.version}" }

  s.source_files  = "Refresh/Refresh/Source/*.{h,m}"
  # s.exclude_files = "Refresh/Refresh/Source/"

  s.public_header_files = "Refresh/Refresh/Source/*.h"

  s.resource  = "Refresh/Refresh/Source/SCRefresh.bundle"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  s.framework  = "UIKit"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
