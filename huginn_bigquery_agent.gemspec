# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "huginn_bigquery_agent"
  spec.version       = '0.1'
  spec.authors       = ["Albert Sun"]
  spec.email         = ["Albert.Sun@nytimes.com"]

  spec.summary       = %q{Write a short summary, because Rubygems requires one.}
  spec.description   = %q{Write a longer description or delete this line.}

  spec.homepage      = "https://github.com/[my-github-username]/huginn_bigquery_agent"

  spec.license       = "MIT"


  spec.files         = Dir['LICENSE.txt', 'lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = Dir['spec/**/*.rb']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "huginn_agent", '~> 0.2'
  spec.add_runtime_dependency "google-cloud-bigquery", '~> 0.27.0'
  # gem 'google-cloud-bigquery', '~> 0.27.0', require: 'google/cloud/bigquery'
end
