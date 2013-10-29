class PhrasingPhraseVersionsController < ActionController::Base

  def delete
    @phrasing_phrase_version = PhrasingPhraseVersions.find(params[:id])
    @phrasing_phrase_version.destroy
    redirect_to @phrasing_phrase_version.phrasing_phrase
  end

end