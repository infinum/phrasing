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
  s.authors     = ['Tomislav Car', 'Damir Svrtan']

  s.files = `git ls-files`.split("\n")  
  s.require_paths = ["lib"]

  s.add_dependency(%q<rails>, [">= 3.1.0"])
  s.add_dependency "railties", ">= 3.1"
  s.add_dependency(%q<haml-rails>)
end
