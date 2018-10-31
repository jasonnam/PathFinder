Pod::Spec.new do |s|
  s.name         = 'PathFinder'
  s.version      = '0.1.0'
  s.summary      = 'PathFinder'
  s.description  = <<-DESC
                   PathFinder
                   DESC
  s.homepage     = 'https://github.com/jasonnam/PathFinder'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'jasonnam' => 'contact@jasonnam.com' }

  s.ios.deployment_target = '11.0'

  s.source       = { :path => '.' }
  s.source_files = 'Sources/PathFinder/**/*.{swift}'
end
