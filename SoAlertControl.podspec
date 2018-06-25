
Pod::Spec.new do |s|
  s.name         = "SoAlertControl"
  s.version      = "1.0.1"
  s.summary      = "自定义AlertView"
  s.homepage     = "https://github.com/lingaoo/SoAlertControl"
  s.license      = "MIT"
  s.author             = { "lingaoo" => "lingaooli@gmail.com" }
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/lingaoo/SoAlertControl.git", :tag => s.version }
  s.source_files  = "SoAlertControl","SoAlertControl/*.{h,m}"
  s.frameworks = "Foundation", "CoreGraphics", "UIKit"
  s.requires_arc = true
end
