require 'phrasing'
require "phrasing/implementation"
require "phrasing/simple"
require 'phrasing/phrasable_error_handler'

module Phrasing
  module Rails
    class Engine < ::Rails::Engine
      initializer :assets, :group => :all do
        ::Rails.application.config.assets.precompile += %w(phrasing_engine.css phrasing.css)
      end
      initializer "phrasing" do
        ActiveSupport.on_load(:action_controller) do
          # ActionController::Base.send(:include, PhrasableErrorHandler)
        end
      end
    end
  end
end


module Phrasing
  
  mattr_accessor :allow_update_on_all_models_and_attributes
  mattr_accessor :route
  mattr_accessor :everything_is_html_safe
  mattr_accessor :staging_server_endpoint

  @@route = 'phrasing'
  @@everything_is_html_safe = false

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

module ActionView
  module Helpers
    module TranslationHelper
      private

      def new_html_safe_translation_key?(key)
        Phrasing.everything_is_html_safe || old_html_safe_translation_key?(key)
      end

      alias_method :old_html_safe_translation_key?, :html_safe_translation_key?
      alias_method :html_safe_translation_key?, :new_html_safe_translation_key?

    end
  end
end
