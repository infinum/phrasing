namespace :phrasing do
  desc "Install the plugin, including the migration."
  task :install do
    Rake::Task["phrasing_rails_engine:install:migrations"].invoke
    Rake::Task["phrasing:install_initializer"].invoke
    Rake::Task["phrasing:phrasable_creator"].invoke
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
    puts "You can change the default route and whitelist editable attributes in the phrasing initializer created in the config/intiializers folder."
  end


  desc "Create the Phrasable module file"
  task :phrasable_creator do
    filepath = Rails.root.join *%w(app controllers concerns phrasable.rb)

    dir = File.dirname(filepath)
    
    unless File.directory?(dir)
      FileUtils.mkdir_p(dir)
    end

    File.open(filepath, 'w') do |f|
      f << <<-MODULE 
module Phrasable
  # You must implement the can_edit_phrases? method. Restart the server on every change to the method.
  # Example:
  # current_user.is_admin?

  def can_edit_phrases?
    raise NotImplementedError.new("You must implement the can_edit_phrases? method")
  end
end
      MODULE
    end
    greenify("A Phrasable module has been created in your app/controllers/concerns folder.")
    greenify("Now run 'rake db:migrate'.")
  end


end

def greenify(text)
  puts "\033[#{32}m#{text}\033[0m"
end