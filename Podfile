# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Schedule' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # ignore all warnings from all pods
  inhibit_all_warnings!
  
  # Pods for Schedule
  pod 'Realm', '~> 5'
  pod 'RealmSwift', '~> 5'
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'

  target 'ScheduleTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ScheduleUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
         end
    end
  end
end
