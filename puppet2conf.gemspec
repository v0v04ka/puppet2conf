# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "puppet2conf/version"

Gem::Specification.new do |spec|
  spec.name    = "puppet2conf"
  spec.version = Puppet2conf::VERSION
  spec.authors = ["Vladimir Tyshkevich"]
  spec.email   = ["vtyshkevich@iponweb.net"]

  spec.summary = %q{Gets XHTML Confluence storage and push it to Confluence}
  spec.license = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f)}
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "md2conf"
  spec.add_runtime_dependency "strings2conf"
  spec.add_runtime_dependency "puppet-strings"
  spec.add_runtime_dependency "confluence-api-client"
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
