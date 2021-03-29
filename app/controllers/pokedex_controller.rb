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
      species = pokemons.species.get
    end

    @pokemon_desc = ''

    species.flavor_text_entries.each {|k|
      @pokemon_desc = k.flavor_text if k.language.name == 'en' && k.version.name == 'red'
    }

    @pokemon_name = pokemons.name.capitalize
    @pokemon_id = pokemons.id
    
    height_arr = height_converter(pokemons.height)
    @ft = height_arr[0]
    @inches = height_arr[1]

    @abilities = []

    pokemons.abilities.each {|k|
      @abilities << k.ability.name.gsub('-',' ').split.map(&:capitalize).join(' ')
    }
  end

  def find_pokemon(pokemon_choice)
    response = PokeApi.get(pokemon: "#{pokemon_choice}")
  end

  def height_converter(height)
    final = []
    first_conv = (height*3.94)/12
    second_conv = first_conv.to_s.split('.')
    final << second_conv[0]
    final << second_conv[1][0..1]
    final
  end
end
