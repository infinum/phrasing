namespace :phrasing do
  desc "Install the plugin, including the migration."
  task :install do
    Rake::Task["phrasing_rails_engine:install:migrations"].invoke
    Rake::Task["phrasing:install_initializer"].invoke
  end

  task :install_initializer do
    require 'digest'
    username = (Digest::SHA2.new << rand.to_s).to_s[0..6]
    password = (Digest::SHA2.new << rand.to_s).to_s[0..6]
    filepath = Rails.root.join *%w(config initializers phrasing.rb)
    File.open(filepath, 'w') do |f|
      f << <<-CONFIG
Phrasing.setup do |config|
  config.username = '#{username}'
  config.password = '#{password}'
end

# Phrasing.whitelist = ["Post.title", "Post.description"]
# Phrasing.allow_update_on_all_models_and_attributes = true;
CONFIG
    end
    puts <<-INFO
Phrasing initializer created with
  username: #{username}
  password: #{password}
Now run 'rake db:migrate'.
    INFO
  end
end
