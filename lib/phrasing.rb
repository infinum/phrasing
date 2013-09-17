# require "copycat/engine"
require "copycat/implementation"
require "copycat/routes"
require "copycat/simple"
require 'copycat'
require 'phrasing/phrasable_error_handler'
require 'phrasing/not_whitelisted_attribute_error'
require 'bootstrap-editable-rails'

module Phrasing
  module Rails
    class Engine < ::Rails::Engine
      initializer :assets, :group => :all do
        ::Rails.application.config.assets.precompile += %w(copycat_engine.css)
      end
      initializer "phrasing" do
        ActiveSupport.on_load(:action_controller) do
          # ActionController::Base.send(:include, PhrasableErrorHandler)
        end
        ::ActiveSupport.on_load(:action_view) do
          ::ActionView::Base.send :include, Bootstrap::Editable::Rails::ViewHelper
        end
      end
    end
  end
end


module Phrasing
  
  mattr_accessor :allow_update_on_all_models_and_attributes

  WHITELIST = "CopycatTranslation.value"
  
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

  def self.check_if_whitelisted!(klass,attribute)
    unless self.allow_update_on_all_models_and_attributes == true
      raise BlacklistedAttributeError if self.whitelist.exclude? "#{klass}.#{attribute}"
    end
  end

end