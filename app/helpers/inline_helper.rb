module InlineHelper
# Normal phrase
# phrase("headline", url: www.infinum.co/yabadaba, inverse: true, interpolation: {min: 15, max: 20}, scope: "models.errors")

# Data model phrase
# phrase(@record, :title, inverse: true, class: phrase-record-title)

  def phrase(*args)
    if args[0].class == String or args[0].class == Symbol
      key, options = args[0].to_s, args[1]
      phrasing_phrase(key,options || {})
    else
      record, field_name, options = args[0], args[1], args[2]
      inline(record, field_name, options || {})
    end
  end

  def inline(record, field_name, options={})
    return record.send(field_name).to_s.html_safe unless can_edit_phrases?

    klass = 'phrasable'
    klass += ' phrasable_on' if edit_mode_on?
    klass += ' inverse' if options[:inverse]
    klass += options[:class] if options[:class]

    url = phrasing_polymorphic_url(record, field_name)

    content_tag(:span, { class: klass, contenteditable: edit_mode_on?, spellcheck: false,   "data-url" => url}) do
      (record.send(field_name) || record.try(:key)).to_s.html_safe
    end
  end

  alias_method :model_phrase, :inline

  private

    def phrasing_phrase(key, options = {})
      key = options[:scope] ? "#{options[:scope]}.#{key}" : key.to_s
      if can_edit_phrases?
        @record = PhrasingPhrase.where(key: key, locale: I18n.locale.to_s).first || PhrasingPhrase.search_i18n_and_create_phrase(key)
        inline(@record, :value, options)
      else
        options.try(:[], :interpolation) ? t(key, options[:interpolation]).html_safe : t(key).html_safe
      end
    end

    def edit_mode_on?
      if cookies["editing_mode"].nil?
        cookies['editing_mode'] = "true"
        true
      else
        cookies['editing_mode'] == "true"
      end
    end

    def phrasing_polymorphic_url(record, attribute)
      remote_update_phrase_phrasing_phrases_path(klass: record.class.to_s, id: record.id, attribute: attribute)
    end

end
