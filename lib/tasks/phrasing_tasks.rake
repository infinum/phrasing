namespace :phrasing do
  desc "Install the plugin, including the migration."
  task :install do
    Rake::Task["phrasing_rails_engine:install:migrations"].invoke
    Rake::Task["phrasing:install_initializer"].invoke
    Rake::Task["phrasing:install_phrasing_helper"].invoke
  end

  desc "Create the initializer file"
  task :install_initializer do
    filepath = Rails.root.join *%w(config initializers phrasing.rb)
    if File.exists?(filepath)
      alert "Phrasing config file already exists."
    else
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
      notice("created")
      puts " config/intiializers/phrasing.rb"
    end
  end


  desc "Create the PhrasingHelper file"
  task :install_phrasing_helper do
    filepath = Rails.root.join *%w(app helpers phrasing_helper.rb)
    if File.exists?(filepath)
      alert "A phrasing helper already exists."
    else    
      File.open(filepath, 'w') do |f|
        f << <<-MODULE 
module PhrasingHelper
  # You must implement the can_edit_phrases? method.
  # Example:
  #
  # def can_edit_phrases?
  #  current_user.is_admin?
  # end

  def can_edit_phrases?
    raise NotImplementedError.new("You must implement the can_edit_phrases? method")
  end
end
      MODULE
      end
      notice("created")
      puts " app/helpers/phrasing_helper.rb" 
      notice "Now run 'rake db:migrate'."
    end 
  end


end

def notice(text)
  puts "\033[#{32}m#{text}\033[0m"
end

def alert(text)
  puts "\033[#{31}m#{text}\033[0m"
end