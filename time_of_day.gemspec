# -*- encoding: utf-8 -*-
require File.expand_path('../lib/time_of_day/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'time_of_day'
  gem.version       = TimeOfDay::VERSION
  gem.summary       = 'Handles time within a day.'
  gem.description   = gem.summary

  gem.authors       = ['Aaron Lasseigne']
  gem.email         = ['aaron@orgsync.com']

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
