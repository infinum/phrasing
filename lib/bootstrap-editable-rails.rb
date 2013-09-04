module Bootstrap
  module Editable
    module Rails
      module ViewHelper
        # Returns +text+ transformed into HTML suitable for textarea input.
        def textarea_format(text)
          html_escape(text).gsub(/\r\n|\r|\n/, '<br>').html_safe
        end
      end
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
