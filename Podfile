# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'SuperSales' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  #  pod 'AnyFormatKit'
  pod 'ReachabilitySwift'
  pod 'SwiftLint'
  pod 'DropDown'
  pod 'GoogleMaps','~> 3.0.0'
  pod 'GooglePlaces'
  pod 'SDWebImage'
  pod 'SVPullToRefresh'
  pod 'EVReflection/Alamofire'
  pod 'DACircularProgress'
  pod 'pop'
  pod 'BarcodeScanner'
  pod 'StepSlider'
  #pod 'DGCharts'
  pod 'Charts'
  pod 'PaddingLabel', '1.2'
  #pod 'Google-Mobile-Ads-SDK' #For Add
  #pod 'SwiftCharts', '~> 0.6.5'
  # pod 'KVKCalendar'
  # pod 'CVCalendar', '~> 1.7.0'
  pod 'FSCalendar'
  # Pods for SuperSales
  pod 'Alamofire'
  pod 'SVProgressHUD'
  pod "JSONParserSwift"
  pod 'MagicalRecord', '~> 2.3'
  pod 'FastEasyMapping'
  pod 'IQKeyboardManagerSwift', '~> 6.5.6'
  #pod 'CarbonKit', '~> 2.1.10'
  pod 'CarbonKit'
  pod 'Toast', '~> 3.1.0'
  pod 'LMGeocoder'
  pod "MonthYearPicker", '~> 4.0.2'
  
  pod 'AlamofireObjectMapper', '~> 5.1.0'
  pod 'ACFloatingTextfield-Swift', '~> 1.8'
  pod 'UIFloatLabelTextView'
  pod 'GoogleUtilities'
  
  pod 'Firebase/Core'
  # pod 'Fabric'
  # pod 'Crashlytics'
  pod 'FirebaseCrashlytics' #Firebase/Crashlytics
  pod 'Firebase/Crashlytics'
  # Recommended: Add the Firebase pod for Google Analytics
  pod 'Firebase/Analytics'
  
end

target 'SuperSalesTests' do
  inherit! :search_paths
  # Pods for testing
end

target 'SuperSalesUITests' do
  inherit! :search_paths
  # Pods for testing
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    
    if target.name == 'BoringSSL-GRPC'
      target.source_build_phase.files.each do |file|
        if file.settings && file.settings['COMPILER_FLAGS']
          flags = file.settings['COMPILER_FLAGS'].split
          flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
          file.settings['COMPILER_FLAGS'] = flags.join(' ')
        end
      end
    end
    
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
    end
  end
end

