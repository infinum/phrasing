class PhrasingPhrase < ActiveRecord::Base

  validates_presence_of :key, :locale
  validate :uniqueness_of_key_on_locale_scope, on: :create

  has_many :versions, dependent: :destroy, class_name: PhrasingPhraseVersion

  after_update :version_it

  def self.find_phrase(key)
    where(key: key, locale: I18n.locale.to_s).first || search_i18n_and_create_phrase(key)
  end

  private

    def self.search_i18n_and_create_phrase(key)
      begin
        value = I18n.t(key, raise: true)
        create_phrase(key, value)
      rescue I18n::MissingTranslationData
        create_phrase(key)
      end
    end

    def self.create_phrase(key, value=nil)
      phrasing_phrase = PhrasingPhrase.new
      phrasing_phrase.locale = I18n.locale.to_s
      phrasing_phrase.key    = key.to_s
      phrasing_phrase.value  = value || key.to_s
      phrasing_phrase.save
      phrasing_phrase
    end

    def uniqueness_of_key_on_locale_scope
      if PhrasingPhrase.where(key: key, locale: locale).any?
        errors.add(:key, "Duplicate entry #{key} for locale #{locale}")
      end
    end

    def version_it
      PhrasingPhraseVersion.create_version(id, value_was) if value_was != value
    end

end