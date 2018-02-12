module Phrasing
  module Serializer
    class << self
      
      def import_yaml(yaml)
        number_of_changes = 0
        hash = YAML.load(yaml)

        hash.each do |locale, data|
          flatten_the_hash(data).each do |key, value|
            phrase = PhrasingPhrase.where(key: key, locale: locale).first || PhrasingPhrase.new(key: key, locale: locale)
            if phrase.value != value
              phrase.value = value
              number_of_changes += 1
              phrase.save
            end
          end
        end
        
        number_of_changes
      end

      def flatten_the_hash(hash)
        new_hash = {}
        hash.each do |key, value|
          if value.is_a? Hash
            flatten_the_hash(value).each do |k,v| 
              new_hash["#{key}.#{k}"] = v
            end
          else
            new_hash[key] = value
          end
        end
        new_hash
      end

      def export_yaml
        hash = {}
        PhrasingPhrase.where("value is not null").each do |phrase|
          hash[phrase.locale] ||= {}
          hash[phrase.locale][phrase.key] = phrase.value
        end
        hash.to_yaml
      end

    end
  end
end