module PhrasableErrorHandler
  extend ActiveSupport::Concern
  included do
    rescue_from "Phrasing::AmbiguousPhrasesError", with: :phrasing_error
    def phrasing_error(e)
      render text: e.message
    end
  end
end