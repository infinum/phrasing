module Phrasing
  module Rails
    class Engine < ::Rails::Engine
      initializer :assets, group: :all do
        ::Rails.application.config.assets.paths << ::Rails.root.join('app', 'assets', 'fonts')
        ::Rails.application.config.assets.paths << ::Rails.root.join('app', 'assets', 'images')
        ::Rails.application.config.assets.precompile +=  %w(editor.js
                                                            phrasing_engine.css
                                                            phrasing_engine.js
                                                            icomoon.dev.svg
                                                            icomoon.svg
                                                            icomoon.eot
                                                            icomoon.ttf
                                                            icomoon.woff
                                                            phrasing_icon_edit_all.png)
      end
    end
  end
end