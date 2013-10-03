module InlineHelper
  def phrase(key, options = {}, *args)
    if can_edit_phrases?
      @record = PhrasingPhrase.where(key: key).first
      if @record.blank?
        @record = PhrasingPhrase.create_phrase(key)
      end
      inline(@record, :value, options)
    else
      t(key, *args)
    end
  end

  def inline(record, field_name, options={})
    return record.send(field_name).to_s.html_safe unless can_edit_phrases?

    content_tag(:span, { class: 'phrasable', contenteditable: true, "data-klass" => record.class.to_s, "data-attribute" => field_name, "data-id" => record.id }) do 
      (record.send(field_name) || record.try(:key) || "#{field_name}-#{record.id}").to_s.html_safe
    end

  end

  alias_method :model_phrase, :inline

  private

    def phrasing_polymorphic_url(object, attribute = nil)
      controller_route = Phrasing.route
      "#{root_url}#{controller_route}/remote_update_phrase?class=#{object.class.to_s}&id=#{object.id}&attribute=#{attribute}"
    end

end