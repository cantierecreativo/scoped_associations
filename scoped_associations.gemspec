# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scoped_associations/version'

Gem::Specification.new do |spec|
  spec.name          = 'scoped_associations'
  spec.version       = ScopedAssociations::VERSION
  spec.authors       = ['Stefano Verna']
  spec.email         = ['stefano.verna@gmail.com']
  spec.description   = %q{ScopedAssociations lets you create multiple `has_to` and `has_many` associations between two ActiveRecord models.}
  spec.summary       = %q{Create multiple `has_to` and `has_many` associations between two ActiveRecord models}
  spec.homepage      = 'https://github.com/stefanoverna/scoped_associations'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'coveralls'

  spec.required_ruby_version = ">= 1.9.3"

  spec.add_dependency 'activerecord', ['>= 3.2', '~> 4.0.0']
  spec.add_dependency 'activesupport'
end

