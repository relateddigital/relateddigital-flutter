#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint relateddigital_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'relateddigital_flutter'
  s.version          = '0.3.0'
  s.summary          = 'Related Digital Flutter SDK'
  s.description      = 'Related Digital Flutter SDK'
  s.homepage         = 'http://relateddigital.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Related Digital' => 'developer@relateddigital.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Euromsg', '2.4.0'
  s.dependency 'VisilabsIOS', '3.0.9'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
