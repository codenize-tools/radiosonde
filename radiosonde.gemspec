# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'radiosonde/version'

Gem::Specification.new do |spec|
  spec.name          = 'radiosonde'
  spec.version       = Radiosonde::VERSION
  spec.authors       = ['Genki Sugawara']
  spec.email         = ['sgwr_dts@yahoo.co.jp']
  spec.description   = "Radiosonde is a tool to manage CloudWatch Alarm. It defines the state of CloudWatch Alarm using DSL, and updates CloudWatch Alarm according to DSL."
  spec.summary       = "Radiosonde is a tool to manage CloudWatch Alarm."
  spec.homepage      = 'http://radiosonde.codenize.tools/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'aws-sdk', '>= 1.50.0'
  spec.add_dependency "json"
  spec.add_dependency "term-ansicolor"
  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '>= 3.0.0'
end
