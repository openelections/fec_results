# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fec_results/version'

Gem::Specification.new do |spec|
  spec.name          = "fec_results"
  spec.version       = FecResults::VERSION
  spec.authors       = ["Derek Willis"]
  spec.email         = ["dwillis@gmail.com"]
  spec.description   = %q{Parses FEC federal election results into Ruby objects}
  spec.summary       = %q{House, Senate, Presidential results}
  spec.homepage      = ""
  spec.license       = "Apache"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "remote_table"
  spec.add_dependency "roo-xls"
  spec.add_dependency "american_date"
end
