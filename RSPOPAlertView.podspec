Pod::Spec.new do |s|
  s.name         = "RSPOPAlertView"
  s.version      = "0.0.1"
  s.summary      = "Fullscreen pop-able and block-able alert view."
  s.homepage     = "https://github.com/yeahdongcn/RSPOPAlertView"
  s.license      = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author       = { "R0CKSTAR" => "yeahdongcn@gmail.com" }
  s.platform     = :ios, '6.0'
  s.source       = { :git => 'https://github.com/yeahdongcn/RSPOPAlertView.git', :tag => "#{s.version}" }
  s.source_files = 'Classes/*.{h,m}'
  s.resources    = "Classes/*.xib"
  s.frameworks   = ['UIKit']
  s.requires_arc = true
  s.dependency     "pop", "~> 1.0.4"
end