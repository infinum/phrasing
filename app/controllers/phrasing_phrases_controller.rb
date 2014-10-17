class PhrasingPhrasesController < Phrasing.parent_controller.constantize

  layout 'phrasing'

  protect_from_forgery

  include PhrasingHelper

  before_filter :authorize_editor

  def import_export; end
  def help; end

  def index
    params[:locale] ||= I18n.default_locale
    @phrasing_phrases = PhrasingPhrase.fuzzy_search(params[:search], params[:locale])
    @locale_names = PhrasingPhrase.uniq.pluck(:locale)
  end

  def edit
    @phrasing_phrase = PhrasingPhrase.find(params[:id])
  end

  def update
    if request.xhr?
      xhr_phrase_update
    else
      phrase_update
    end
  end

  def download
    app_name = Rails.application.class.to_s.split("::").first
    app_env = Rails.env
    filename = "phrasing_phrases_#{app_name}_#{app_env}_#{Time.now.strftime("%Y_%m_%d_%H_%M_%S")}.yml"
    send_data Phrasing::Serializer.export_yaml, filename: filename
  end

  def upload
      number_of_changes = Phrasing::Serializer.import_yaml(params["file"].tempfile)
      redirect_to phrasing_phrases_path, notice: "YAML file uploaded successfully! Number of phrases changed: #{number_of_changes}."
    rescue => e
      logger.info "\n#{e.class}\n#{e.message}"
      message = if params[:file].nil?
        "Please choose a file."
      else
        "Please upload a valid YAML file."
      end

      flash[:alert] = "There was an error processing your upload! #{message}"
      render action: 'import_export', status: 400
  end

  def destroy
    phrasing_phrase = PhrasingPhrase.find(params[:id])
    phrasing_phrase.destroy
    redirect_to phrasing_phrases_path, notice: "#{phrasing_phrase.key} deleted!"
  end

  private

    def authorize_editor
      redirect_to root_path unless can_edit_phrases?
    end

    def xhr_phrase_update
      klass, attribute = params[:klass], params[:attribute]

      if Phrasing.is_whitelisted?(klass, attribute)
        class_object = klass.classify.constantize
        @object = class_object.where(id: params[:id]).first
        @object.send("#{attribute}=",params[:new_value])
        @object.save!
        render json: @object
      else
        render status: 403, text: "Attribute not whitelisted!"
      end

      rescue ActiveRecord::RecordInvalid => e
        render status: 403, text: e
    end

    def phrase_update
      phrase = PhrasingPhrase.find(params[:id])
      phrase.value = params[:phrasing_phrase][:value]
      phrase.save!

      redirect_to phrasing_phrases_path, notice: "#{phrase.key} updated!"
    end

end
