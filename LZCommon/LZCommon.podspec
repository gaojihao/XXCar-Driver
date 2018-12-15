
Pod::Spec.new do |s|
  s.name             = 'LZCommon'
  s.version          = '1.0.0'
  s.license          = 'MIT'
  s.summary          = 'LZCommon'
  s.author           = { 'lizhi' => 'lizhi1026@126.com' }
  s.ios.deployment_target = '8.0'
  s.source_files = 'LZCommon/Classes/**/*'

  s.homepage = 'https://github.com/gaojihao/XXCar-iOS'
  s.source = {
    :http => 'https://github.com/gaojihao/XXCar-iOS'
  }

  s.public_header_files = 'LZCommon/Classes/**/*.h'
  s.dependency 'AFNetworking'
end
