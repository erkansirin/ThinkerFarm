# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
source 'https://github.com/CocoaPods/Specs.git'

workspace 'ThinkerFarmMain.xcworkspace'

target 'ThinkerFarm' do
    project 'ThinkerFarm/ThinkerFarm.xcodeproj'
    use_frameworks!
end

target 'ThinkerFarmExample' do
    project 'ThinkerFarmExample/ThinkerFarmExample.xcodeproj'
    use_frameworks!
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
