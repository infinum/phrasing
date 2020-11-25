class PhrasingPhrase < ActiveRecord::Base

  validates_presence_of :key, :locale
  # validate :uniqueness_of_key_on_locale_scope, on: :create
  validates_uniqueness_of :key, scope: [:locale]

  has_many :versions, dependent: :destroy, class_name: 'PhrasingPhraseVersion'

  after_update :version_it

  def self.find_phrase(key,default=nil)
    where(key: key, locale: I18n.locale.to_s).first || search_i18n_and_create_phrase(key,default)
  end

  def self.fuzzy_search(search_term, locale)
    query = order(:key)
    query = query.where(locale: locale) if locale.present?

    if search_term.present?
      key_like   = PhrasingPhrase.arel_table[:key].matches("%#{search_term}%")
      value_like = PhrasingPhrase.arel_table[:value].matches("%#{search_term}%")
      query.where(key_like.or(value_like))
    else
      # because we want to have non nil values first.
      query.where("value is not null") + query.where("value is null")
    end
  end

  private

    def self.search_i18n_and_create_phrase(key,default=nil)
      begin
        value = I18n.t(key, raise: true)
        create_phrase(key, value)
      rescue I18n::MissingTranslationData
        create_phrase(key,nil,default)
      end
    end

    def self.create_phrase(key,value=nil, default='empty' )
      phrasing_phrase = PhrasingPhrase.new
      phrasing_phrase.locale = I18n.locale.to_s
      phrasing_phrase.key    = key.to_s
      phrasing_phrase.value  = value || default.to_s || key.to_s
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
