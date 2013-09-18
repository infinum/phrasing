class PhrasingPhrasesController < ActionController::Base

  http_basic_authenticate_with name: Phrasing.username, password: Phrasing.password

  layout 'phrasing'

  def index
    params[:locale] = I18n.default_locale unless params.has_key?(:locale)
    query = PhrasingPhrase
    query = query.where(locale: params[:locale]) unless params[:locale].blank?

    if params.has_key?(:search)
      if params[:search].blank?
        @phrasing_phrases = query.all
      else
        key_like = PhrasingPhrase.arel_table[:key].matches("%#{params[:search]}%")
        value_like = PhrasingPhrase.arel_table[:value].matches("%#{params[:search]}%")
        @phrasing_phrases = query.where(key_like.or(value_like))
      end
    else
      @phrasing_phrases = []
    end
    @locale_names = PhrasingPhrase.find(:all, select: 'distinct locale').map(&:locale)
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
        redirect_to phrasing_phrases_path, :notice => "#{@phrasing_phrase.key} updated!"    
      end

      format.js do
        render :json => @phrasing_phrase
      end
    end
  end

  def import_export
  end

  def download
    app_name = Rails.application.class.to_s.split("::").first
    app_env = Rails.env
    filename = "phrasing_phrases_#{app_name}_#{app_env}_#{Time.now.strftime("%Y_%m_%d_%H_%M_%S")}.yml"
    send_data PhrasingPhrase.export_yaml, :filename => filename
  end

  def upload
    begin
      PhrasingPhrase.import_yaml(params["file"].tempfile)
    rescue Exception => e
      logger.info "\n#{e.class}\n#{e.message}"
      flash[:notice] = "There was an error processing your upload!"
      render :action => 'import_export', :status => 400
    else
      redirect_to phrasing_phrases_path, :notice => "YAML file uploaded successfully!"
    end
  end

  def destroy
    @phrasing_phrase = PhrasingPhrase.find(params[:id])
    notice = "#{@phrasing_phrase.key} deleted!"
    @phrasing_phrase.destroy
    redirect_to phrasing_phrases_path, :notice => notice
  end

  def help
  end

  def sync
    if Phrasing.staging_server_endpoint.nil?
      redirect_to :back, alert: 'You didn\'t set your source server'
    else
      yaml = read_remote_yaml(Phrasing.staging_server_endpoint)

      if yaml
        PhrasingPhrase.import_yaml(yaml)
        redirect_to :back, notice: "Translations synced from source server"
      else
        redirect_to :back
      end

    end
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
end
