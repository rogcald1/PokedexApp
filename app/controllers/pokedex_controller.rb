require 'poke-api-v2'

class PokedexController < ApplicationController
  def index
  end

  def search

    ##initial test for errors, since PokeApi automatically converts info into JSON
    test_res = Excon.get("https://pokeapi.co/api/v2/pokemon/#{params[:pokemon].downcase}")

    if test_res.data[:body] == 'Not Found'
      flash[:alert] = "pokemon not found :/"
      return render action: :index
    else
    ##if initial test passes, then use PokeApi and grab info
      pokemons = find_pokemon(params[:pokemon].downcase) 
    end

    @pokemon_name = pokemons.name.capitalize
    @pokemon_id = pokemons.id
  end

  def find_pokemon(pokemon_choice)
    response = PokeApi.get(pokemon: "#{pokemon_choice}")
  end
end
