#
#  Be sure to run `pod spec lint CHTape.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "CHTape"
  s.version      = "0.1.0"
  s.summary      = "A lightweight & fast Objective-C implementation of a doubly linked list. http://huxtable.ca"

  s.description  = <<-DESC
                  A lightweight & fast Objective-C implementation of a doubly linked list, including a cursor for easy traversal.
                   DESC

  s.homepage     = "https://github.com/chris-huxtable/CHTape"
  s.license      = { :type => "ISC", :file => "LICENCE" }
  s.author       = { "Chris Huxtable" => "chris@huxtable.ca" }

  s.ios.deployment_target = "5.0"
  s.osx.deployment_target = "10.7"
  s.source       = { :git => "https://github.com/chris-huxtable/CHTape.git", :commit => "32850c0f3add59e6b572e7ffa9e18f0d99f35fcf" }

  s.source_files  = "CHTape/*Tape*.{h,m}"
  s.public_header_files = "CHTape/*Tape*.h"

  s.requires_arc = false
end
