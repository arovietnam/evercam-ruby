# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'evercam/version'

Gem::Specification.new do |spec|
  spec.name          = "evercam"
  spec.version       = Evercam::VERSION
  spec.authors       = ["Evercam"]
  spec.email         = ["howrya@evercam.io"]
  spec.summary       = %q{A wrapper for the Evercam API.}
  spec.description   = %q{This library provides a wrapper for using the Evercam API.}
  spec.homepage      = "https://www.evercam.io"
  spec.license       = "Commercial Proprietary"

  spec.files         = Dir.glob("{bin,lib}/**/*") + %w(LICENSE.md README.md CHANGELOG.md)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "mocha", "~> 1.0"
  spec.add_development_dependency "rack-test", "~> 0.6"
  spec.add_development_dependency "rake", "~> 10.2"
  spec.add_development_dependency "rspec", "= 3.2.0"
  spec.add_development_dependency "simplecov", "~> 0.8"
  spec.add_development_dependency "webmock", "~> 1.17"

  spec.add_dependency "faraday", "~> 0.9"
  spec.add_dependency "faraday_middleware", "~> 0.9"
  spec.add_dependency "typhoeus", "~> 0.6"
end
