class CreatePhrasingPhraseVersions < ActiveRecord::Migration
  def change
    create_table :phrasing_phrase_versions do |t|
      t.integer :phrasing_phrase_id
      t.text :value
      t.timestamps
    end
    add_index :phrasing_phrase_versions, :phrasing_phrase_id
  end
end