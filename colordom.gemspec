require_relative 'lib/colordom/version'

Gem::Specification.new do |spec|
  spec.name          = 'colordom'
  spec.version       = Colordom::VERSION
  spec.authors       = ['Jonian Guveli']
  spec.email         = ['jonian@hardpixel.eu']

  spec.summary       = %q{Extract dominant colors from images}
  spec.description   = %q{Extract dominant colors from images using native extension implemented in Rust.}
  spec.homepage      = 'https://github.com/hardpixel/colordom'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|samples)/}) }
  end

  spec.extensions    = ['ext/Rakefile']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'thermite'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 13.0'
end
