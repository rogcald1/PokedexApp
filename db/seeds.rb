require 'poke-api-v2'

for x in (1..3)
    res = PokeApi.get(pokemon: "#{x}")
    Pokemon.create(
        name: res.name.capitalize,
    )
end

## for later: you can do a lot of what you did in the controller and assign each thing to a variable. 
## after creating the initial pokemon, you can do something like poke = Pokemon.find_or_initialize_by(id: x) and fill in 
## normally, like poke.poke_description = variable