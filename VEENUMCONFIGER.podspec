Pod::Spec.new do |spec|

  spec.name         = "VEENUMCONFIGER"
  spec.version      = "1.1.5"
  spec.summary      = "VEENUMCONFIGER is a library of common resources."
  spec.homepage     = "https://github.com/vefans/VEENUMCONFIGER"
  spec.platform     = :ios, "9.0"
  spec.license      = "MIT"
  spec.author       = { "iOS VESDK Team" => "" }
  spec.source       = { :git => 'https://github.com/vefans/VEENUMCONFIGER.git', :tag => spec.version.to_s}
  
  spec.requires_arc = true  
  spec.dependency 'SDWebImage'
  spec.dependency "SDWebImageWebPCoder", '0.2.3'
  spec.dependency "Reachability"
  spec.dependency "LibVECore"
  spec.dependency "ZipArchive"
  spec.dependency "ATMHud"

  spec.xcconfig = {'CONFIGURATION_BUILD_DIR' => '${PODS_CONFIGURATION_BUILD_DIR}'}
  spec.pod_target_xcconfig ={ 'ALWAYS_SEARCH_USER_PATHS'=>'YES', 'ENABLE_BITCODE' => 'NO' }
  spec.prefix_header_contents = '#ifdef __OBJC__','#import <VEENUMCONFIGER/VEENUMCONFIGER-PrefixHeader.h>','#endif'

  #包含所有bundle的版本
  spec.subspec 'AllBundle' do |alls|
    alls.source_files = '**/*.{h,m}'
    alls.resources = '**/*.{bundle}'
  end

  #不包含VEDemoUse.bundle的版本
  spec.subspec 'ExcludeDemoBundle' do |es|
    es.source_files = '**/*.{h,m}'
    es.resources = '**/VEEditSDK.{bundle}','**/VideoRecord.{bundle}'
  end

end
