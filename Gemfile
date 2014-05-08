# A sample Gemfile
source "https://rubygems.org"

gemspec

rails_version = ENV["RAILS_VERSION"] || "default"

rails = case rails_version
when "default"
  ">= 3.2.0"
else
  "~> #{rails_version}"
end

gem "rails", rails

gem 'factory_girl_rails'
gem 'haml-rails'
gem 'sqlite3'
gem 'rspec-rails'
gem 'capybara', '~> 2.2.0'
