require 'poke-api-v2'

class PokedexController < ApplicationController
  def index
  end

  def search
    #this adjusts messaging if there was an invalid entry or blank entry
    @pokepoke = params[:current_poke]
    if params[:empty_val]
      @alert1_on = true
    end

    if params[:incorrect]
      @alert2_on = true
    end

    ##checks for empty values and redirects depending on what page they searched from 
    if params[:pokemon] == ''
      flash[:alert] = "please input a pokemon's name or ID"
      if params[:index_source]
        return render action: :index
      elsif !params[:index_source] && params[:pokemon] == ''
        return redirect_to :action => "search", :pokemon => @pokepoke, :empty_val => true
      end
    end
    ##initial test for errors, since PokeApi automatically converts info into JSON
    # test_res = Excon.get("https://pokeapi.co/api/v2/pokemon/#{params[:pokemon].downcase}")

    if !Pokemon.exists?(params[:pokemon]) && !Pokemon.exists?(name: "#{params[:pokemon].capitalize}")
      flash[:alert] = "pokemon not found :/"
      if params[:index_source]
        return render action: :index
      elsif !params[:index_source] && (!Pokemon.exists?(params[:pokemon]) && !Pokemon.exists?(name: "#{params[:pokemon].capitalize}"))
        return redirect_to :action => "search", :pokemon => @pokepoke, :incorrect => true
      end
    else
    ##if initial test passes, then use PokeApi and grab info
      flash[:alert] = ""  
      if Pokemon.exists?(params[:pokemon])
        pokemons = Pokemon.where(id: params[:pokemon])
      elsif Pokemon.exists?(name: "#{params[:pokemon].capitalize}")
        pokemons = Pokemon.where(name: "#{params[:pokemon].capitalize}")
      end
    end

    @pokemon_name = pokemons.first.name
    @pokemon_id = pokemons.first.poke_id
    @pokemon_desc = pokemons.first.description
    @poke_category = pokemons.first.category
    @poke_height = pokemons.first.height
    @weight = pokemons.first.weight
    @poke_types = pokemons.first.types
    @abilities = pokemons.first.abilities
    @names = pokemons.first.evolution

  end
end
