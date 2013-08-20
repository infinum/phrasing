namespace :copycat do
  desc "Install the plugin, including the migration."
  task :install do
    # Rake::Task["copycat_engine:install:migrations"].invoke
    Rake::Task["copycat:install_initializer"].invoke
  end

  task :install_initializer do
    require 'digest'
    username = (Digest::SHA2.new << rand.to_s).to_s[0..6]
    password = (Digest::SHA2.new << rand.to_s).to_s[0..6]
    filepath = Rails.root.join *%w(config initializers copycat.rb)
    File.open(filepath, 'w') do |f|
      f << <<-CONFIG
Copycat.setup do |config|
  config.username = '#{username}'
  config.password = '#{password}'
  #config.route = 'copycat_translations'
  #config.everything_is_html_safe = true
  #config.staging_server_endpoint = "http://staging.yourapp.com/copycat_translations/download"
end
CONFIG
    end
    puts <<-INFO
Copycat initializer created with
  username: #{username}
  password: #{password}
Now run 'rake db:migrate'.
    INFO
  end
end
