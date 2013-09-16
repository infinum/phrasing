Rails.application.routes.draw do
  # Copycat.routes(self)
  resources Copycat.route, :as => 'copycat_translations', :controller => 'copycat_translations', :only => [:index, :edit, :update, :destroy] do
    collection do
      get 'help'
      get 'import_export'
      get 'sync'
      get 'download'
      post 'upload'
    end
  end
  get 'phrasing/update_phrase', to: 'phrasing#update_phrase'
end
