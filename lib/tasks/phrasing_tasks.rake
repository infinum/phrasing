namespace :phrasing do
  desc "Install the plugin, including the migration."
  task :install do
    Rake::Task["phrasing_rails_engine:install:migrations"].invoke
    Rake::Task["phrasing:install_initializer"].invoke
  end

  desc "Create the initializer file"
  task :install_initializer do
    filepath = Rails.root.join *%w(config initializers phrasing.rb)
    File.open(filepath, 'w') do |f|
      f << <<-CONFIG
Phrasing.setup do |config|
  config.route = 'phrasing'
end

# List all the model attributes you wish to edit with Phrasing, example:
# Phrasing.whitelist = ["Post.title", "Post.description"]
Phrasing.whitelist = []
# Phrasing.allow_update_on_all_models_and_attributes = true;
CONFIG
    end
    puts <<-INFO
You can change the default route in the phrasing initializer created in the config/intiializers folder.
Now run 'rake db:migrate'.
    INFO
  end
end
