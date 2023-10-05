Pod::Spec.new do |spec|
  spec.name         = 'SKObservableUIKit'
  spec.module_name = "ObservableUIKit"
  spec.version      = '0.0.2'
  spec.summary      = <<-DESC
  Library for writing UIKit parameter Observablely.
  DESC
  spec.description  = <<-DESC
  This Library for writing UIKit parameter Observablely.
  Thank you!!
  DESC
  spec.homepage     = 'https://github.com/sakiyamaK/ObservableUIKit'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'Kei Sakiyama' => 'sakiyama.k@gmail.com' }
  spec.source       = { :git => 'https://github.com/sakiyamaK/ObservableUIKit.git', :tag => spec.version.to_s }
  spec.ios.deployment_target = '17.0'
  spec.source_files = 'Sources/ObservableUIKit/**/*'
  spec.swift_versions = '5.9'
  spec.static_framework = true
end
