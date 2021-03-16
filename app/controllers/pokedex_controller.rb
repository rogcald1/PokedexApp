require 'poke-api-v2'

class PokedexController < ApplicationController
  def index
  end

  def search

    ##initial test for error
    test_res = Excon.get("https://pokeapi.co/api/v2/pokemon/#{params[:pokemon]}")

    if test_res.data[:body] == 'Not Found'
      flash[:alert] = "pokemon not found :/"
      return render action: :index
    else
      pokemons = find_pokemon(params[:pokemon]) 
    end

    @pokemon_name = pokemons.name
  end

  def find_pokemon(pokemon_choice)
    response = PokeApi.get(pokemon: "#{pokemon_choice}")
  end
end
