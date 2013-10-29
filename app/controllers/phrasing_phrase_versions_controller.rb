class PhrasingPhraseVersionsController < ActionController::Base

  def destroy
    @phrasing_phrase_version = PhrasingPhraseVersion.find(params[:id])
    @phrasing_phrase_version.destroy
    redirect_to edit_phrasing_phrase_path(@phrasing_phrase_version.phrasing_phrase.id)
  end

end