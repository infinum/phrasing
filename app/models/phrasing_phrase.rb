class PhrasingPhrase < ActiveRecord::Base

  unless ENV['PHRASING_DEBUG']
    self.logger = Logger.new('/dev/null')
  end

  validates_presence_of :key, :locale
  # validates_uniqueness_of :key, uniqueness: {scope: :locale}
  validate :uniqueness_of_key_on_locale_scope, on: :create


  def uniqueness_of_key_on_locale_scope
    errors.add(:key, "Duplicate entry #{key} for locale #{locale}") unless PhrasingPhrase.where(key: key).where(locale: locale).empty?
  end

  def self.create_phrase(key)
    phrasing_phrase = PhrasingPhrase.new
    phrasing_phrase.locale = I18n.locale
    phrasing_phrase.key = key.to_s
    phrasing_phrase.value = key.to_s.humanize
    phrasing_phrase.save!
    phrasing_phrase
  end

  module Serialize

    def import_yaml(yaml)
      number_of_changes = 0
      hash = YAML.load(yaml)
      hash.each do |locale, data|
        data.each do |key, value|
          phrase = where(key: key, locale: locale).first || new(key: key, locale: locale)
          if phrase.value != value
            phrase.value = value
            number_of_changes += 1
            phrase.save
          end
        end
      end
      number_of_changes
    end

    def export_yaml
      hash = {}
      where("value is not null").each do |phrase|
        hash[phrase.locale] ||= {}
        hash[phrase.locale][phrase.key] = phrase.value
      end
      hash.to_yaml
    end

  end

  extend Serialize

end
