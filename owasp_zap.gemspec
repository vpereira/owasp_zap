# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'owasp_zap/version'

Gem::Specification.new do |spec|
  spec.name          = "owasp_zap"
  spec.version       = OwaspZap::VERSION
  spec.authors       = ["Victor Pereira"]
  spec.email         = ["vpereira@suse.de"]
  spec.description   = %q{ruby wrapper for ZAP}
  spec.summary       = %q{ruby wrapper for the zed application proxy}
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

