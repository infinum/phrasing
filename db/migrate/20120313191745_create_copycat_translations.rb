class CreateCopycatTranslations < ActiveRecord::Migration
  def change
    create_table :copycat_translations do |t|    
      t.string :locale
      t.string :key
      t.text :value
      t.index [:locale, :key], :unique => true
      t.timestamps
    end
  end
end
