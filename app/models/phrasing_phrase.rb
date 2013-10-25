class PhrasingPhrase < ActiveRecord::Base

  unless ENV['PHRASING_DEBUG']
    self.logger = Logger.new('/dev/null')
  end

  validates_presence_of :key, :locale
  # validates_uniqueness_of :key, uniqueness: {scope: :locale}
  validate :uniqueness_of_key_on_locale_scope, on: :create
  # These validation methods are used so the YAML file can be exported/imported properly.
  validate :check_ambiguity, on: :create, :unless => Proc.new { |phrase| phrase.key.nil? }
  validate :key_must_not_end_with_a_dot, on: :create, :unless => Proc.new { |phrase| phrase.key.nil? }


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
      hash = YAML.load(yaml)
      hash.each do |locale, data|
        hash_flatten(data).each do |key, value|
          c = where(key: key, locale: locale).first
          c ||= new(key: key, locale: locale)
          c.value = value
          c.save
        end
      end
    end

    # {"foo"=>{"a"=>"1", "b"=>"2"}} ----> {"foo.a"=>1, "foo.b"=>2}
    def hash_flatten(hash)
      result = {}
      hash.each do |key, value|
        if value.is_a? Hash
          hash_flatten(value).each { |k,v| result["#{key}.#{k}"] = v }
        else
          result[key] = value
        end
      end
      result
    end

    def export_yaml
      hash = {}
      where("value is not null").each do |c|
        hash_fatten!(hash, [c.locale].concat(c.key.split(".")), c.value)
      end
      hash.to_yaml
    end

    # ({"a"=>{"b"=>{"e"=>"f"}}}, ["a","b","c"], "d") ----> {"a"=>{"b"=>{"c"=>"d", "e"=>"f"}}}
    def hash_fatten!(hash, keys, value)
      if keys.length == 1
        hash[keys.first] = value
      else
        head = keys.first
        rest = keys[1..-1]
        hash[head] ||= {}
        hash_fatten!(hash[head], rest, value)
      end
    end

  end

  extend Serialize

  private

    def check_ambiguity
      check_ambiguity_on_ancestors
      check_ambiguity_on_successors
    end

    def check_ambiguity_on_ancestors
      stripped_key = key
      while stripped_key.include?('.')
        stripped_key = stripped_key.split('.')[0..-2].join('.')
        if PhrasingPhrase.where(key: stripped_key).count > 0
            errors.add(:key, "can't be named '#{key}', there already exists a key named '#{stripped_key}'. Ambiguous calling!")
        end
      end
    end

    def check_ambiguity_on_successors
      key_successor = "#{key}."
      if PhrasingPhrase.where(PhrasingPhrase.arel_table[:key].matches("#{key_successor}%")).count > 0
        errors.add(:key, "can't be named '#{key}', there already exists one or multiple keys beginning with '#{key_successor}'. Ambiguous calling!")
      end
    end

    def key_must_not_end_with_a_dot
      errors.add(:key, "mustn't end with a dot") if key[-1] == "."
    end

end
