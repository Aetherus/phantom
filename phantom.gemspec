# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'phantom/version'

Gem::Specification.new do |spec|
  spec.name          = "phantom"
  spec.version       = Phantom::VERSION
  spec.authors       = ["Aetherus"]
  spec.email         = ["sasabune0122@gmail.com"]
  spec.description   = %q{This gem is developed to implement callback mechanism to sub processes.}
  spec.summary       = %q{This gem is developed to implement callback mechanism to sub processes. Not production ready.}
  spec.homepage      = "https://github.com/Aetherus/phantom"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
