source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
inhibit_all_warnings!

install! 'cocoapods',
  :generate_multiple_pod_projects => true

post_install do |installer|
  if installer.pods_project
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
  end
end

def using_pods

    pod 'CocoaLumberjack', :modular_headers => true
    pod 'MJRefresh',                '~> 3.1.15.7'
    pod 'AFNetworking',             '~> 3.2.1'
    pod 'Masonry',                  '~> 1.1.0'
      
end


target 'vipIosVersion' do
    using_pods
end
 
 
