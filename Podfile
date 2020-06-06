# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'


target 'pokemonfinder' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Networking Pods
  pod 'Alamofire',              '~> 4.7.3'
  pod 'AlamofireImage'

  # UI/UX Pods  
  pod 'SnapKit',                '~> 4.2.0'
  pod 'IQKeyboardManagerSwift', '~> 6.0.4'
  pod 'SpringIndicator',        '~> 4.0.0'

  # Utilities
  pod 'R.swift',                '~> 5.0.3'  
  pod 'StatefulViewController', '~> 3.0'
  pod 'SwiftLint',              '~> 0.37'
  pod 'RealmSwift'
  
  # Rx Pods
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxSwiftExt'
  pod 'RxSwiftUtilities',       :git => 'https://github.com/RxSwiftCommunity/RxSwiftUtilities', :branch => 'master'
  pod "RxGesture"
  pod "RxRealm"

  target 'pokemonfinderTests' do
    inherit! :search_paths
      pod 'Nimble',         '~> 7.3.4'
      pod 'Quick',          '~> 1.3.4'
      pod 'RxNimble', subspecs: ['RxBlocking', 'RxTest']
  end

  target 'pokemonfinderUITests' do
    # Pods for testing
  end

end
