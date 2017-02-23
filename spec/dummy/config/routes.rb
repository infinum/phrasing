Dummy::Application.routes.draw do
  root to: "site#index"
  get 'example', to: 'site#example'
end
