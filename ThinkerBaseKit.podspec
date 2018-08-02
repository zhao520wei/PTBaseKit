Pod::Spec.new do |s|
  s.name         = "ThinkerBaseKit"
  s.version      = "0.2.0"
  s.summary      = "Utils for iOS project"
  s.description  = "Due to lots of iOS projects, need to moduler to increase development speed."
  s.homepage     = "http://git.thinker.vc/chenjianchang/ThinkerBaseKit.git"
  s.license      = "Apache License, Version 2.0"
  s.author       = { "Oreo" => "p36348@gmail.com" }
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "http://git.thinker.vc/chenjianchang/ThinkerBaseKit.git", :branch => 'master', :tag => "#{s.version}" }
  s.source_files  = "ThinkerBaseKit/Source/*.swift", "ThinkerBaseKit/Source/**/*.swift"

  s.dependency 'SnapKit', '= 3.2.0'
  s.dependency 'RxCocoa', '~> 4.1.2'
  s.dependency 'RxSwift', '~> 4.1.2'
  s.dependency 'MJRefresh', '= 3.1.15.1'
  s.dependency 'MBProgressHUD', '= 1.1.0'
  s.dependency 'Kingfisher', '~> 3.0'
end
