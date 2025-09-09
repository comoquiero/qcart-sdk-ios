Pod::Spec.new do |s|
  s.name             = 'QcartSDK'
  s.version          = '1.0.0'
  s.summary          = 'Qcart iOS SDK'
  s.description      = <<-DESC
The native iOS SDK for handling Qcart deeplinks and cart parsing.
  DESC
  s.homepage         = 'https://github.com/comoquiero/qcart-sdk-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Qcart' => 'dev@qcart.com' }
  s.source           = { :git => 'https://github.com/comoquiero/qcart-sdk-ios.git', :tag => s.version.to_s }

  s.platform         = :ios, '15.0'
  s.swift_version    = '5.0'

  # Include your Swift sources
  s.source_files     = 'Sources/QcartSDK/**/*.{swift}'
end