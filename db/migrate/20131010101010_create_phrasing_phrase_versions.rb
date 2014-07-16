class CreatePhrasingPhraseVersions < ActiveRecord::Migration
  def change
    create_table :phrasing_phrase_versions do |t|    
      t.references :phrasing_phrase
      t.text :value
      t.timestamps
    end
  end
end
