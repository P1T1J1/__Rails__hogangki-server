Rails.application.routes.draw do
  resources :news

  get '/searchresult' => 'news#searchresult'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
