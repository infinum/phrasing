# This migration comes from phrasing_rails_engine (originally 20131010101010)
class CreatePhrasingPhraseVersions < ActiveRecord::Migration
  def change
    create_table :phrasing_phrase_versions do |t|    
      t.integer :phrasing_phrase_id
      t.text :value
      t.timestamps
    end
  end
end
