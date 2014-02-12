# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_event_logger/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_event_logger"
  spec.version       = RailsEventLogger::VERSION
  spec.authors       = ["Thomas Himbert"]
  spec.email         = ["thimbert@avarteq.de"]
  spec.summary       = "History for all sort of changes to models or whatever"
  spec.description   = "A simple gem to log changes of all sort"
  spec.homepage      = "https://github.com/th1988/rails_event_logger.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency 'rake', '~> 0'
  spec.add_runtime_dependency 'rails'
  spec.add_runtime_dependency 'activerecord'
  spec.add_runtime_dependency 'protected_attributes'
end
