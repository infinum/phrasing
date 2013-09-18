class CopycatTranslationsController < ActionController::Base

  http_basic_authenticate_with name: Phrasing.username, password: Phrasing.password

  layout 'copycat'

  def index
    params[:locale] = I18n.default_locale unless params.has_key?(:locale)
    query = CopycatTranslation
    query = query.where(locale: params[:locale]) unless params[:locale].blank?

    if params.has_key?(:search)
      if params[:search].blank?
        @copycat_translations = query.all
      else
        key_like = CopycatTranslation.arel_table[:key].matches("%#{params[:search]}%")
        value_like = CopycatTranslation.arel_table[:value].matches("%#{params[:search]}%")
        @copycat_translations = query.where(key_like.or(value_like))
      end
    else
      @copycat_translations = []
    end
    @locale_names = CopycatTranslation.find(:all, select: 'distinct locale').map(&:locale)
  end

  def edit
    @copycat_translation = CopycatTranslation.find(params[:id])
  end

  def update
    @copycat_translation = CopycatTranslation.find(params[:id])
    @copycat_translation.value = params[:copycat_translation][:value]
    @copycat_translation.save!

    respond_to do |format|
      format.html do
        redirect_to copycat_translations_path, :notice => "#{@copycat_translation.key} updated!"    
      end

      format.js do
        render :json => @copycat_translation
      end
    end
  end

  def import_export
  end

  def download
    app_name = Rails.application.class.to_s.split("::").first
    app_env = Rails.env
    filename = "copycat_translations_#{app_name}_#{app_env}_#{Time.now.strftime("%Y_%m_%d_%H_%M_%S")}.yml"
    send_data CopycatTranslation.export_yaml, :filename => filename
  end

  def upload
    begin
      CopycatTranslation.import_yaml(params["file"].tempfile)
    rescue Exception => e
      logger.info "\n#{e.class}\n#{e.message}"
      flash[:notice] = "There was an error processing your upload!"
      render :action => 'import_export', :status => 400
    else
      redirect_to copycat_translations_path, :notice => "YAML file uploaded successfully!"
    end
  end

  def destroy
    @copycat_translation = CopycatTranslation.find(params[:id])
    notice = "#{@copycat_translation.key} deleted!"
    @copycat_translation.destroy
    redirect_to copycat_translations_path, :notice => notice
  end

  def help
  end

  def sync
    if Copycat.staging_server_endpoint.nil?
      redirect_to :back, alert: 'You didn\'t set your source server'
    else
      yaml = read_remote_yaml(Copycat.staging_server_endpoint)

      if yaml
        CopycatTranslation.import_yaml(yaml)
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
      open(url, http_basic_authentication: [Copycat.username, Copycat.password]) do |remote|
        output = remote.read()
      end
    rescue Exception => e
      logger.fatal e
      flash[:alert] = "Syncing failed: #{e}"
    end
    output
  end
end
