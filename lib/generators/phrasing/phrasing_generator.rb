class PhrasingGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path('../templates', __FILE__)

  def create_initializer_file
    initializer_location = "config/initializers/phrasing.rb"
    copy_file initializer_location, initializer_location
  end

  def create_helper_file
    helper_location = "app/helpers/phrasing_helper.rb"
    copy_file helper_location, helper_location
  end

  def create_migrations
    phrasing_phrase_migration = "db/migrate/create_phrasing_phrases.rb"
    migration_template phrasing_phrase_migration, phrasing_phrase_migration
    phrase_versions_migration = "db/migrate/create_phrasing_phrase_versions.rb"
    migration_template phrase_versions_migration, phrase_versions_migration
  end

  def self.next_migration_number(path)
    sleep 1 # migration numbers should differentiate
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

  def migration_version
    if rails5?
      "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
    end
  end

  def rails5?
    Rails.version.start_with? '5'
  end
end
