module InlineHelper

  def phrase(key, options = {}, *args)
    if can_edit_phrases?
      @record = PhrasingPhrase.where(key: key).first || PhrasingPhrase.create_phrase(key)
      inline(@record, :value, options)
    else
      t(key, *args)
    end
  end

  def inline(record, field_name, options={})
    return record.send(field_name).to_s.html_safe unless can_edit_phrases?

    klass = 'phrasable'
    klass += ' phrasable_on' if edit_mode_on?
    klass += ' inverse' if options[:inverse]

    url = phrasing_polymorphic_url(record, field_name)

    content_tag(:span, { class: klass, contenteditable: edit_mode_on?, spellcheck: false,   "data-url" => url}) do 
      (record.send(field_name) || record.try(:key) || "#{field_name}-#{record.id}").to_s.html_safe
    end

  end

  alias_method :model_phrase, :inline

  private

    def edit_mode_on?
      if cookies["editing_mode"].nil?
        cookies['editing_mode'] = "true"
        true
      else  
        cookies['editing_mode'] == "true"
      end
    end


    def phrasing_polymorphic_url(record, attribute)
      resource = Phrasing.route
      "#{root_url}#{resource}/remote_update_phrase?klass=#{record.class.to_s}&id=#{record.id}&attribute=#{attribute}"
    end

end