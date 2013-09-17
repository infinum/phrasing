# require "copycat/engine"
require "copycat/implementation"
require "copycat/routes"
require "copycat/simple"
require 'copycat'
require 'phrasing/phrasable_error_handler'
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
    raise StandardError if self.whitelist.exclude? "#{klass}.#{attribute}"
  end

end