class PhrasingController < ActionController::Base

  def update_phrase
    klass, attribute = params[:class], params[:attribute]
    if Phrasing.is_whitelisted?(klass, attribute)
      class_object = klass.classify.constantize
      @object = class_object.where(id: params[:id]).first
      @object.update_attributes({attribute => params[:new_value]})
      render :json => @copycat_translation
    else
      render status: 403, text: "#{klass}.#{attribute} not whitelisted."
    end    
  end

end