module Copycat
  
  def self.routes(mapper)
    mapper.instance_eval do
      resources Copycat.route, :as => 'copycat_translations', :controller => 'copycat_translations', :only => [:index, :edit, :update, :destroy] do
        collection do
          get 'help'
          get 'import_export'
          get 'sync'
          get 'download'
          post 'upload'
        end
      end
      resources CopyCat.route, as: 'phrasing', controller: 'phrasing' do
        collection do
          post 'update_phrase'
        end
      end
    end



  end
end
