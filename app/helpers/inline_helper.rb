module InlineHelper

  # Normal phrase
  # phrase("headline", url: www.infinum.co/yabadaba, inverse: true, scope: "models.errors")
  # Data model phrase
  # phrase(record, :title, inverse: true, class: phrase-record-title)
  def phrase(*args)
    if args[0].class.in? [String, Symbol]
      key, options = args[0].to_s, (args[1] || {})
      inline(extract_record(key, options), :value, options)
    else
      record, attribute, options = args[0], args[1], args[2]
      inline(record, attribute, options || {})
    end
  end

  private

  def inline(record, attribute, options = {})
    return uneditable_phrase(record, attribute) unless can_edit_phrases?

    klass  = 'phrasable phrasable_on'
    klass += ' inverse'      if options[:inverse]
    klass += options[:class] if options[:class]

    url = phrasing_polymorphic_url(record, attribute)

    content_tag(:span, class: klass, contenteditable: true, spellcheck: false, 'data-url' => url) do
      (record.send(attribute) || record.try(:key)).to_s.html_safe
    end
  end

  def extract_record(key, options = {})
    key = options[:scope] ? "#{options[:scope]}.#{key}" : key
    PhrasingPhrase.find_phrase(key)
  end

  def uneditable_phrase(record, attribute)
    record.public_send(attribute).to_s.html_safe
  end

  def phrasing_polymorphic_url(record, attribute)
    phrasing_phrase_path(klass: record.class.to_s, id: record.id, attribute: attribute)
  end

end
