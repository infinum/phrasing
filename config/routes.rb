Rails.application.routes.draw do
  resources Phrasing.route, :as => 'phrasing_phrases', :controller => 'phrasing_phrases', :only => [:index, :edit, :update, :destroy] do
    collection do
      get 'help'
      get 'import_export'
      get 'sync'
      get 'download'
      post 'upload'
    end
  end
  put 'phrasing/update_phrase/', to: 'phrasing#update_phrase'
end
