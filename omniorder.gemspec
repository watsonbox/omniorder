# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniorder/version'

Gem::Specification.new do |spec|
  spec.name          = "omniorder"
  spec.version       = Omniorder::VERSION
  spec.authors       = ["Howard Wilson"]
  spec.email         = ["howard@watsonbox.net"]
  spec.summary       = %q{Import online orders from various channels for fulfillment.}
  spec.description   = %q{Import online orders from various channels for fulfillment.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "crack", "~> 0.4.2"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.1.0"
  spec.add_development_dependency "webmock", "~> 1.20.4"
  spec.add_development_dependency "coveralls"
end
