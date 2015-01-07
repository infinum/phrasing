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
  s.license     = "MIT"

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency "rails", ">= 3.2.0"
  s.add_dependency "railties", ">= 3.2"
  s.add_dependency "haml"
  s.add_dependency "jquery-rails"
  s.add_dependency "jquery-cookie-rails"
  s.add_dependency "sass"

  s.add_development_dependency 'pry'
end
