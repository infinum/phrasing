class CreatePhrasingPhraseVersions < ActiveRecord::Migration
  def change
    create_table :phrasing_phrase_versions do |t|    
      t.references :phrasing_phrase, index: true
      t.text :value
      t.timestamps
    end
  end
end
