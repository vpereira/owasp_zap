# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zap/version'

Gem::Specification.new do |spec|
  spec.name          = "zap"
  spec.version       = Zap::VERSION
  spec.authors       = ["Victor Pereira"]
  spec.email         = ["vpereira@suse.de"]
  spec.description   = %q{TODO: ruby wrapper for zed attack proxy API}
  spec.summary       = %q{TODO: ruby wrapper to access the HTTP API exposed by zed attack proxy (ZAP)}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "webmock"
  spec.add_dependency "rest-client"
  spec.add_dependency "addressable"
end
