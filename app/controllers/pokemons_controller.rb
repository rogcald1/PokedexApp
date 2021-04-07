class PokemonsController < ApplicationController
    def index
        render({json: Pokemon.all})
    end
end
