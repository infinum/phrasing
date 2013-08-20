module Copycat
  class Engine < ::Rails::Engine

    if Rails.version >= '3.1'
      initializer :assets, :group => :all do
        Rails.application.config.assets.precompile += %w(copycat_engine.css)
      end
    end

  end
end
