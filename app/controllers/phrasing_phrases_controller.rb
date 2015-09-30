class PhrasingPhrasesController < Phrasing.parent_controller.constantize

  layout 'phrasing'

  protect_from_forgery

  include PhrasingHelper

  before_filter :authorize_editor

  def index
    params[:locale] ||= I18n.default_locale
    query = PhrasingPhrase
    query = query.order(:key)
    query = query.where(locale: params[:locale]) unless params[:locale].blank?

    if params[:search] and !params[:search].blank?
        key_like = PhrasingPhrase.arel_table[:key].matches("%#{params[:search]}%")
        value_like = PhrasingPhrase.arel_table[:value].matches("%#{params[:search]}%")
        @phrasing_phrases = query.where(key_like.or(value_like))
    else
      @phrasing_phrases = query.where("value is not null") + query.where("value is null")
    end

    @locale_names = PhrasingPhrase.uniq.pluck(:locale)
  end

  def edit
    @phrasing_phrase = PhrasingPhrase.find(params[:id])
  end

  def update
    @phrasing_phrase = PhrasingPhrase.find(params[:id])
    @phrasing_phrase.value = params[:phrasing_phrase][:value]
    @phrasing_phrase.save!

    respond_to do |format|
      format.html do
        redirect_to phrasing_phrases_path, notice: "#{@phrasing_phrase.key} updated!"
      end

      format.js do
        render json: @phrasing_phrase
      end
    end
  end

  def import_export
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
    rescue Exception => e
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
    @phrasing_phrase = PhrasingPhrase.find(params[:id])
    @phrasing_phrase.destroy
    redirect_to phrasing_phrases_path, notice: "#{@phrasing_phrase.key} deleted!"
  end

  def help
  end

  def sync
    if Phrasing.staging_server_endpoint.nil?
      redirect_to :back, alert: "You didn't set your source server"
    else
      yaml = read_remote_yaml(Phrasing.staging_server_endpoint)

      if yaml
        Phrasing::Serializer.import_yaml(yaml)
        redirect_to :back, notice: "Translations synced from source server"
      else
        redirect_to :back
      end

    end
  end

  def remote_update_phrase
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

  protected

    def read_remote_yaml(url)
      output = nil
      begin
        open(url, http_basic_authentication: [Phrasing.username, Phrasing.password]) do |remote|
          output = remote.read()
        end
      rescue Exception => e
        logger.fatal e
        flash[:alert] = "Syncing failed: #{e}"
      end
      output
    end


    def authorize_editor
      redirect_to root_path unless can_edit_phrases?
    end

end
