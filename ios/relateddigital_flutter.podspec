Pod::Spec.new do |s|
  s.name             = 'relateddigital_flutter'
  s.version          = '1.0.0'
  s.summary          = 'Related Digital Flutter SDK'
  s.description      = 'Related Digital Flutter SDK'
  s.homepage         = 'https://relateddigital.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Related Digital' => 'developer@relateddigital.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'RelatedDigitalIOS', '4.0.8'
  s.platform = :ios, '10.0'
  s.swift_version = '5.0'
end
