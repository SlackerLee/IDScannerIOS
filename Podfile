# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!
inhibit_all_warnings!

def available_pods

  pod 'Alamofire', '~> 4.9.1'
  pod 'ReachabilitySwift', '~> 5.0'
  pod 'ObjectMapper', '~> 4.2'
  pod 'Toast-Swift', '~> 5.0'
  pod 'SwiftyJSON', '~> 5.0'
  
end

target 'IDScanner' do

  available_pods

end


post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        if config.name == 'Release'
            config.build_settings['SWIFT_COMPILATION_MODE'] = 'wholemodule'
        end
        if config.name == 'Release'
            config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
            else
            config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
        end
    end

    installer.pods_project.build_configurations.each do |config|
       config.build_settings.delete('CODE_SIGNING_ALLOWED')
       config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
    
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end
