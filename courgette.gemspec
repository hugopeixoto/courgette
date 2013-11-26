# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'courgette/version'

Gem::Specification.new do |spec|
  spec.name          = "courgette"
  spec.version       = Courgette::VERSION
  spec.authors       = ["Hugo Peixoto"]
  spec.email         = ["hugo.peixoto@gmail.com"]
  spec.description   = %q{Static ruby dependency analyser}
  spec.summary       = %q{Courgette analyses a set of files, and calculates a dependency graph}
  spec.homepage      = "https://github.com/hugopeixoto/courgette"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ruby_parser"
  spec.add_dependency "commander"
  spec.add_dependency "graph"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "mocha"
end
