#
# Be sure to run `pod lib lint RBUtils.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "RBUtils"
  s.version          = "0.0.1"
  s.summary          = "Some useful categories, etc."
  s.description      = <<-DESC
                       Misc utils
                       DESC
  s.homepage         = "https://github.com/kwyee/RBUtils"
  s.license          = 'MIT'
  s.author           = { "Kenson Yee" => "kenson.yee+rb@gmail.com" }
  s.source           = { :git => "https://github.com/kwyee/RBUtils.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  #s.resources = ['Pod/Assets/Scripts/*']
  s.exclude_files = ['RBUtils.xcodeproj', 'RBUtils.xcworkspace', 'RBUtilsTests']

  s.public_header_files = 'RBUtils/**/*.h'
  s.requires_arc = true

  s.default_subspec = 'Core'

  s.subspec 'Core' do |ss|
    ss.source_files = 'RBUtils/'
    ss.frameworks = 'Foundation', 'QuartzCore'
    ss.dependency 'CocoaLumberjack'
  end


end
