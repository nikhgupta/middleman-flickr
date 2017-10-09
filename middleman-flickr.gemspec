$LOAD_PATH.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'middleman-flickr'
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nikhil Gupta']
  s.email       = ['me@nikhgupta.com']
  s.homepage    = 'https://github.com/nikhgupta/middleman-flickr'
  s.summary     = 'Middleman extension to display images from Flickr'
  s.description = 'Middleman extension to display images from Flickr'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency('middleman-core', ['>= 4.2.1'])
  s.add_runtime_dependency('flickraw')
end
