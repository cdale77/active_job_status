# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_job_status/version'

Gem::Specification.new do |spec|
  spec.name          = "active_job_status"
  spec.version       = ActiveJobStatus::VERSION
  spec.authors       = ["Brad Johnson"]
  spec.email         = ["cdale77@gmail.com"]
  spec.summary       = "Job status and batches for ActiveJob"
  spec.description   = "Job status and batches for ActiveJob. Create trackable jobs, check their status, and batch them together."
  spec.homepage      = "https://github.com/cdale77/active_job_status"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 0.4"

  spec.add_runtime_dependency "activejob", "~>4.2"
  spec.add_runtime_dependency "activesupport", "~>4.2"
end
