# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'temp_editor'

Gem::Specification.new do |gem|
  gem.name          = "temp_editor"
  gem.version       = TempEditor::VERSION
  gem.authors       = ["riverpuro"]
  gem.email         = ["riverpuro@gmail.com"]
  gem.description   = %q{Edit temporary file with ENV['EDITOR']}
  gem.summary       = %q{Edit temporary file with ENV['EDITOR']}
  gem.homepage      = "https://github.com/riverpuro/temp_editor"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency('rspec')
end
