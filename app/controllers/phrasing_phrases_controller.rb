class PhrasingPhrasesController < Phrasing.parent_controller.constantize

  layout 'phrasing'

  protect_from_forgery

  include PhrasingHelper

  before_action :authorize_editor

  def import_export
  end

  def help
  end

  def index
    params[:locale] ||= I18n.default_locale
    @phrasing_phrases = phrasing_phrases
    @locale_names = PhrasingPhrase.distinct.pluck(:locale)
  end

  def edit
    @phrasing_phrase = PhrasingPhrase.find(params[:id])
  end

  def update
    request.xhr? ? xhr_phrase_update : phrase_update
  end

  def download
    app_name = Rails.application.class.to_s.split("::").first
    app_env = Rails.env
    time = Time.now.strftime('%Y_%m_%d_%H_%M_%S')
    filename = "phrasing_phrases_#{app_name}_#{app_env}_#{time}.yml"
    send_data Phrasing::Serializer.export_yaml(phrasing_phrases), filename: filename
  end

  def upload
    number_of_changes = Phrasing::Serializer.import_yaml(params["file"].tempfile)
    redirect_to phrasing_phrases_path, notice: "YAML file uploaded successfully! Number of phrases changed: #{number_of_changes}."
  rescue => e
    message = if params[:file].nil?
                'Please choose a file.'
              else
                'Please upload a valid YAML file.'
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

    return render status: 403, text: 'Phrase not whitelisted' unless Phrasing.whitelisted?(klass, attribute)

    record = klass.classify.constantize.find(params[:id])

    if record.update(attribute => params[:new_value])
      render json: record
    else
      render status: 403, json: record.error.full_messages
    end
  end

  def phrase_update
    phrase = PhrasingPhrase.find(params[:id])
    phrase.value = params[:phrasing_phrase][:value]
    phrase.save!

    redirect_to phrasing_phrases_path, notice: "#{phrase.key} updated!"
  end

  def phrasing_phrases
    PhrasingPhrase.fuzzy_search(params[:search], params[:locale])
  end

end
