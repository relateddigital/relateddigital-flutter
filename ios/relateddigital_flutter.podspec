#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint relateddigital_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'relateddigital_flutter'
  s.version          = '0.8.0'
  s.summary          = 'Related Digital Flutter SDK'
  s.description      = 'Related Digital Flutter SDK'
  s.homepage         = 'https://relateddigital.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Related Digital' => 'developer@relateddigital.com' }
  s.source           = { :path => '.' }
  s.source_files = 'relateddigital_flutter/Sources/relateddigital_flutter/**/*.swift'
  s.dependency 'Flutter'
  s.dependency 'Euromsg', '2.7.2'
  s.dependency 'VisilabsIOS', '4.5.0'
  s.platform = :ios, '15.0'

  s.swift_version = '5.0'
end
