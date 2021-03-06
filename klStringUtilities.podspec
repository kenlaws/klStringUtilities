#
#  Be sure to run `pod spec lint klStringUtilities.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "klStringUtilities"
  s.version      = "1.0.5"
  s.summary      = "A small set of Swift string utilities and shortcuts."
  s.description  = <<-DESC
	This is a small set of Swift 4.0 based string utilities providing some simple
	shortcuts and conveniences that, well, I found useful. Maybe you will, too.
                   DESC

  s.homepage     = "https://github.com/kenlaws/klStringUtilities"
  s.license      = "MIT"
  s.author             = { "Ken Laws" => "pods@kenlaws.com" }
  s.social_media_url   = "https://twitter.com/kenlaws"

  #  When using multiple platforms
  s.ios.deployment_target = "11.0"
  # s.osx.deployment_target = "10.12"
  s.watchos.deployment_target = "4.0"
  s.tvos.deployment_target = "11.0"

  s.source       = { :git => "https://github.com/kenlaws/klStringUtilities.git", :tag => s.version.to_s }

  s.source_files  = "klStringUtilities"
  s.framework = "UIKit"
  s.requires_arc = true

end
