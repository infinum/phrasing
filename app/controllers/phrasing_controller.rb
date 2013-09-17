class PhrasingController < ActionController::Base

  def update_phrase
    if params[:class] and params[:attribute]
      update_model_phrase
    else
      update_non_model_phrase
    end
  end

  private

  def update_model_phrase
    klass = params[:class]
    attribute = params[:attribute]

    class_object = klass.classify.constantize
    @object = class_object.where(id: params[:id]).first
    @object.update_attributes({attribute => params[:new_value]})

    render :json => @copycat_translation
  end

  def update_non_model_phrase
    @copycat_translation = CopycatTranslation.find(params[:id])
    @copycat_translation.value = params[:new_value]
    @copycat_translation.save!
    
    render :json => @copycat_translation
  end

end