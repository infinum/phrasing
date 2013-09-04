require 'bootstrap-editable-rails/version'
require 'bootstrap-editable-rails/view_helper'

module Bootstrap
  module Editable
    module Rails
      class Engine < ::Rails::Engine
        initializer 'bootstrap-editable-rails' do
          ::ActiveSupport.on_load(:action_view) do
            ::ActionView::Base.send :include, Bootstrap::Editable::Rails::ViewHelper
          end
        end
      end
    end
  end
end
