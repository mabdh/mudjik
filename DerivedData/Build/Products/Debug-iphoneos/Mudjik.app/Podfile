platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!

target 'Mudjik' do
    pod 'Alamofire', '~> 4.0'
    pod 'SwiftyJSON'
    pod 'ImgurAnonymousAPIClient', :git => 'https://github.com/nolanw/ImgurAnonymousAPIClient.git', :tag => 'v0.1.1'
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
