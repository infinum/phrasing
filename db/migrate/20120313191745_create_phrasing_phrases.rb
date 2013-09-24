class CreatePhrasingPhrases < ActiveRecord::Migration
  def change
    create_table :phrasing_phrases do |t|    
      t.string :locale
      t.string :key
      t.text :value
      t.timestamps
    end
    add_index :phrasing_phrases, [:locale, :key], :unique => true
  end
end
