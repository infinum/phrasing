# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "phrasing/version"

Gem::Specification.new do |s|
  s.name        = "phrasing"
  s.version     = Phrasing::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Edit phrases inline for Rails applications!"
  s.email       = "contact@infinum.co"
  s.homepage    = "http://github.com/infinum/phrasing"
  s.description = "Phrasing!"
  s.authors     = ['Tomislav Car']

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.require_paths = ["lib"]

#  s.add_dependency('copycat')
  s.add_dependency(%q<rails>, [">= 3.1.0"])
  s.add_dependency(%q<haml-rails>)
  s.add_dependency('bootstrap-editable-rails')
  #s.add_dependency('actionpack', '~> 3.0')
end
