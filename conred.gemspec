# -*- encoding: utf-8 -*-
require File.expand_path('../lib/conred/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Janis Miezitis"]
  gem.email         = ["janjiss@gmail.com"]
  gem.description   = %q{Gem to remove repetative tasks}
  gem.summary       = %q{Comrades are for reusable code}
  gem.homepage      = "http://github.com/janjiss/conred"

  gem.add_dependency "haml", '~> 3'
  gem.add_dependency "typhoeus", '~> 0.6'
  gem.add_dependency "actionpack", '~> 3'
  gem.add_development_dependency "rspec", '~> 2.0'
  gem.add_development_dependency "rake", '~> 10.1'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "conred"
  gem.require_paths = ["lib"]
  gem.version       = Conred::VERSION
end
