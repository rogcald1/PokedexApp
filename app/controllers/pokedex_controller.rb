require 'poke-api-v2'

class PokedexController < ApplicationController
  def index
  end

  def search
    pokemons = find_pokemon(params[:pokemon])

    unless pokemons
      flash[:alert] = "pokemon not found :/"
      return render action: :index
    end

    private

    def find_pokemon(pokemon_choice)
      response = PokeApi.get(pokemon: "#{pokemon_choice}") 

      return nil if response.status != 200

      JSON.parse(response.body)
    end

  end
end
