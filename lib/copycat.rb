# require "phrasing/engine"
require "phrasing/implementation"
# require "phrasing/routes"
require "phrasing/simple"

module Copycat
  mattr_accessor :username
  mattr_accessor :password
  mattr_accessor :route
  mattr_accessor :everything_is_html_safe
  mattr_accessor :staging_server_endpoint

  @@route = 'phrasing_phrases'
  @@everything_is_html_safe = false

  def self.setup
    yield self
  end
end

module ActionView
  module Helpers
    module TranslationHelper
      private

      def new_html_safe_translation_key?(key)
        Copycat.everything_is_html_safe || old_html_safe_translation_key?(key)
      end

      alias_method :old_html_safe_translation_key?, :html_safe_translation_key?
      alias_method :html_safe_translation_key?, :new_html_safe_translation_key?

    end
  end
end
