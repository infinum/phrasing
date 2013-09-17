module InlineHelper
  def phrase(key, options = {})
    if current_user
      @object = CopycatTranslation.where(key: key).first

      if @object.blank?
        @object = CopycatTranslation.create_phrase(key)
      end
      inline(@object, :value)
    else
      t(key)
    end
  end

  def model_phrase(object, attribute)
    if current_user
      inline(object, attribute)
    else
      object.send(attribute).to_s.html_safe
    end
  end

  def phrasing_polymorphic_url(object, attribute = nil)
    basic_url = "#{root_url}phrasing/update_phrase"
    if object.class == CopycatTranslation
      query_parameters = "?id=#{object.id}"
    else
      query_parameters = "?class=#{object.class.to_s.downcase}&id=#{object.id}&attribute=#{attribute}"
    end
    basic_url + query_parameters
  end

  def inline(object, field_name, options = {})
    if current_user.blank?
      return object.send(field_name).to_s.html_safe
    end

    if options[:as].blank?
      options[:as] = "textarea"
    end

    options[:url] ||= phrasing_polymorphic_url(object, field_name)

    html_options = {
      "href" => '#',
      "class" => "inline-editable inline-editable-#{options[:as]}",
      #"id" => "username",  #"#{object.class.name}_#{object.id}_field_name",
      "data-type" => options[:as],
      # "data-resource" => object.class.name.underscore,
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
        # "$('.inline-edit-link').click(function(e) {
        #   $(this).prev().editable('toggle')
        #   e.stopPropagation();
        #   return false;        
        # });".html_safe
      end      
    end

  end
end