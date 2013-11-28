class PhrasingPhraseVersion < ActiveRecord::Base
  belongs_to :phrasing_phrase

  def self.create_version(phrasing_phrase_id, value)
    phrasing_phrase_version = PhrasingPhraseVersion.new
    phrasing_phrase_version.phrasing_phrase_id = phrasing_phrase_id
    phrasing_phrase_version.value = value
    phrasing_phrase_version.save
  end
  
end