# -*- encoding: utf-8 -*-
require File.expand_path('../lib/conred/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Janis Miezitis"]
  gem.email         = ["janjiss@gmail.com"]
  gem.description   = %q{Safely and easily embed videos}
  gem.summary       = %q{Safely and easily embed YouTube and Videmo videos}
  gem.homepage      = "http://github.com/janjiss/conred"

  gem.add_development_dependency "rspec", '~> 2.0'
  gem.add_development_dependency "rake", '~> 10.1'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "conred"
  gem.require_paths = ["lib"]
  gem.version       = Conred::VERSION
end
