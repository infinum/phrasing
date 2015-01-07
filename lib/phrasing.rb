require 'phrasing'
require "phrasing/implementation"
require "phrasing/simple"
require "phrasing/serializer"
require 'jquery-rails'
require 'jquery-cookie-rails'
require 'haml'

module Phrasing
  module Rails
    class Engine < ::Rails::Engine
      initializer :assets, group: :all do
        ::Rails.application.config.assets.paths << ::Rails.root.join('app', 'assets', 'fonts')
        ::Rails.application.config.assets.paths << ::Rails.root.join('app', 'assets', 'images')
        ::Rails.application.config.assets.precompile += ['editor.js', 'phrasing_engine.css', 'phrasing_engine.js', 'icomoon.dev.svg', 'icomoon.svg', 'icomoon.eot', 'icomoon.ttf', 'icomoon.woff', 'phrasing_icon_edit_all.png']
      end
    end
  end
end


module Phrasing

  mattr_accessor :allow_update_on_all_models_and_attributes
  mattr_accessor :route
  mattr_accessor :staging_server_endpoint
  mattr_accessor :parent_controller

  @@parent_controller = "ApplicationController"
  @@route = 'phrasing'

  def self.log
    @@log
  end

  def self.log=(log_value)
    @@log = log_value
    suppress_log if log_value == false
  end

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

  private

    def self.suppress_log
      logger_class = defined?(ActiveSupport::Logger) ? ActiveSupport::Logger::SimpleFormatter : Logger::SimpleFormatter

      logger_class.class_eval do

        alias_method :old_call, :call

        def call(severity, timestamp, progname, msg)
          unless (msg.include? "SELECT" and (msg.include? "phrasing_phrases" or msg.include? "phrasing_phrase_versions"))
            old_call(severity, timestamp, progname, msg)
          end
        end

      end
    end


end
