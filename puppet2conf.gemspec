# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppet2conf/version'

Gem::Specification.new do |spec|
  spec.name          = 'puppet2conf'
  spec.version       = Puppet2conf::VERSION
  spec.authors       = ['Vladimir Tyshkevich', 'Eugene Piven']
  spec.email         = ['vtyshkevich@iponweb.net', 'epiven@iponweb.net']
  spec.summary       = 'Gets XHTML Confluence storage and push it to Confluence'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'md2conf'
  spec.add_runtime_dependency 'puppet-strings', '>= 2.0.0'
  spec.add_runtime_dependency 'conf-api-client'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
