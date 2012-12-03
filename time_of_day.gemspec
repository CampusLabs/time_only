# -*- encoding: utf-8 -*-
require File.expand_path('../lib/time_of_day/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'time_of_day'
  gem.version       = TimeOfDay::VERSION
  gem.summary       = 'A simple class for handling time and only time.'
  gem.description   = "#{gem.summary} No dates, no time zones, just good old time of day."

  gem.authors       = ['Aaron Lasseigne']
  gem.email         = ['aaron@orgsync.com']

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'timecop'
end
