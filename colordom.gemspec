# frozen_string_literal: true

require_relative 'lib/colordom/version'

Gem::Specification.new do |spec|
  spec.name          = 'colordom'
  spec.version       = Colordom::VERSION
  spec.authors       = ['Jonian Guveli']
  spec.email         = ['jonian@hardpixel.eu']

  spec.summary       = 'Extract dominant colors from images'
  spec.description   = 'Extract dominant colors from images using native extension implemented in Rust.'
  spec.homepage      = 'https://github.com/hardpixel/colordom'
  spec.license       = 'MIT'

  spec.files         = Dir['LICENSE.txt', 'README.md', '{ext,lib}/**/*']
  spec.extensions    = ['ext/colordom/extconf.rb']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6'

  spec.add_runtime_dependency 'rb_sys'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake-compiler', '~> 1.2'
end
