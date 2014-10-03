class PhrasingPhraseVersionsController < Phrasing.parent_controller.constantize

  def destroy
    phrase_version = PhrasingPhraseVersion.find(params[:id])
    phrase_version.destroy
    redirect_to edit_phrasing_phrase_path(phrase_version.phrasing_phrase.id)
  end

end