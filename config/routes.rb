Rails.application.routes.draw do
  root 'pokedex#index'

  get '/search' => 'pokedex#search'
end
