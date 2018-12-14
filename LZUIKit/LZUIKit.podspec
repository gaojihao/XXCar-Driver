
Pod::Spec.new do |s|
  s.name             = 'LZUIKit'
  s.version          = '1.0.0'
  s.license          = 'MIT'
  s.summary          = 'LZUIKit'
  s.author           = { 'lizhi' => 'lizhi1026@126.com' }
  s.ios.deployment_target = '8.0'
  s.source_files = 'LZUIKit/Classes/**/*'

  s.homepage = 'https://github.com/gaojihao/XXCar-iOS'
  s.source = {
    :http => 'https://github.com/gaojihao/XXCar-iOS'
  }

  s.public_header_files = 'LZUIKit/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'MBProgressHUD'
  s.dependency 'DQAlertView'
  s.dependency 'Masonry'
end
