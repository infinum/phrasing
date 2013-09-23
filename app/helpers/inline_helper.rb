module InlineHelper
  def phrase(key, options = {})
    if current_user
      @object = PhrasingPhrase.where(key: key).first
      if @object.blank?
        @object = PhrasingPhrase.create_phrase(key)
      end
      inline(@object, :value, options)
    else
      t(key)
    end
  end

  def phrasing_polymorphic_url(object, attribute = nil)
    "#{root_url}phrasing/update_phrase?class=#{object.class.to_s}&id=#{object.id}&attribute=#{attribute}"
  end

  def inline(object, field_name, options = {})
    return object.send(field_name).to_s.html_safe if current_user.blank?

    options[:as] ||= "textarea"
      
    options[:url] ||= phrasing_polymorphic_url(object, field_name)

    html_options = {
      "href" => '#',
      "class" => "inline-editable inline-editable-#{options[:as]}",
      "data-type" => options[:as],
      "data-name" => "new_value",
      "data-url" => options[:url],
      "data-original-title" => "Enter #{field_name.to_s.humanize}"
    }

    content_tag(:span, {:class => 'inline-editable-container'}) do |variable|
      content_tag(:span, html_options) do
        object.send(field_name).to_s.html_safe
      end +
      content_tag(:span, {:class => 'inline-edit-link'}) do
         "Edit"
      end + 
      content_tag(:script, "type" => "text/javascript" ) do
        "$('.inline-editable-#{options[:as]}').editable({mode: 'popup', placement: 'bottom'});".html_safe
      end      
    end

  end

  alias_method :model_phrase, :inline

end