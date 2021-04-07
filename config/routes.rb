Rails.application.routes.draw do
  resources :pokemons
  root 'pokedex#index'

  get '/search' => 'pokedex#search'
end
