require 'phrasing'
require 'phrasing/serializer'
require 'phrasing/rails/engine'
require 'jquery-rails'
require 'jquery-cookie-rails'
require 'haml-rails'

module Phrasing
  mattr_accessor :allow_update_on_all_models_and_attributes
  @@allow_update_on_all_models_and_attributes = false

  mattr_accessor :route
  @@route = 'phrasing'

  mattr_accessor :parent_controller
  @@parent_controller = "ApplicationController"

  def self.setup
    yield self
  end

  WHITELIST = "PhrasingPhrase.value"

  def self.whitelist
    if defined? @@whitelist
      @@whitelist + [WHITELIST]
    else
      [WHITELIST]
    end
  end

  def self.whitelist=(whitelist)
    @@whitelist = whitelist
  end

  def self.is_whitelisted?(klass,attribute)
    allow_update_on_all_models_and_attributes == true or whitelist.include? "#{klass}.#{attribute}"
  end
end