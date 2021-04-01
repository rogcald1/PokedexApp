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
      evo = species.evolution_chain.get.chain 

    end

    @pokemon_desc = ''
    @abilities = []
    @pokemon_name = pokemons.name.capitalize
    @pokemon_id = pokemons.id
    @poke_types = []
    @poke_category = ''
    link = evo
    name = link.species.name.capitalize
    @names = [name]
    height_arr = height_converter(pokemons.height)
    @ft = height_arr[0]
    @inches = height_arr[1]
    @weight = weight_converter(pokemons.weight)

    species.flavor_text_entries.each {|k|
      @pokemon_desc = k.flavor_text if k.language.name == 'en' && k.version.name == 'red'
    }

    pokemons.abilities.each {|k|
      @abilities << k.ability.name.gsub('-',' ').split.map(&:capitalize).join(' ')
    }

    pokemons.types.each {|k|
      @poke_types << k.type.name.capitalize
    }

    species.genera.each {|k|
      @poke_category = k.genus if k.language.name == 'en'
    }

    while !link.evolves_to.first.nil?
      if link.evolves_to.length > 1
        link.evolves_to.each {|k|
          @names << k.species.name.capitalize
        }
        link = link.evolves_to.first
      else
        link = link.evolves_to.first
        name = link.species.name.capitalize
        @names << name
      end
    end

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

  def weight_converter(weight)
    final = (weight / 4.536).round(1)
    final
  end
end
