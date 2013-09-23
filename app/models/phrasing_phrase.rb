class PhrasingPhrase < ActiveRecord::Base
  require 'phrasing/ambiguous_phrases_error'

  unless ENV['PHRASING_DEBUG']
    self.logger = Logger.new('/dev/null')
  end

  validates_presence_of :key, :locale

  before_create :check_ambiguity

  def self.create_phrase(key)
    phrasing_phrase = PhrasingPhrase.new
    phrasing_phrase.key = key
    phrasing_phrase.value = key.to_s.humanize
    phrasing_phrase.locale = I18n.locale
    phrasing_phrase.save!
    phrasing_phrase
  end

  def check_ambiguity
    check_ambiguity_on_ancestors
    check_ambiguity_on_successors
  end

  def check_ambiguity_on_ancestors
    stripped_key = key
    while stripped_key.include?('.')
      stripped_key = stripped_key.split('.')[0..-2].join('.')
      if PhrasingPhrase.where(key: stripped_key).count > 0
          raise Phrasing::AmbiguousPhrasesError, "Ambiguous calling! There exists a '#{stripped_key}' key, unable to call a new key '#{key}'"
      end
    end
  end

  def check_ambiguity_on_successors
    key_successor = "#{key}."
    if PhrasingPhrase.where(PhrasingPhrase.arel_table[:key].matches("%#{key_successor}%")).count > 0
      raise Phrasing::AmbiguousPhrasesError, "Ambiguous calling! There exists one or multiple keys beginning with '#{key_successor}', unable to call a new key '#{key}'"
    end
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

end
