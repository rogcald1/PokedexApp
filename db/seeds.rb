require 'poke-api-v2'

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

for x in (1..898)
	puts x
  res = PokeApi.get(pokemon: "#{x}")	
  species = res.species.get
  evo = species.evolution_chain.get.chain 

  p = Pokemon.new
  p.name = res.name.capitalize
  p.poke_id = res.id
    
  species.flavor_text_entries.each {|k|
    p.description = k.flavor_text if k.language.name == 'en'
  }

	species.genera.each {|k|
		p.category = k.genus if k.language.name == 'en'
	}

	##need to test if array works**
	p.types = []
	res.types.each {|k|
		p.types << k.type.name.capitalize
	}

	p.abilities = []
	res.abilities.each {|k|
		p.abilities << k.ability.name.gsub('-',' ').split.map(&:capitalize).join(' ')
	}

	height_arr = height_converter(res.height)
	p.height = "#{height_arr[0]}' #{height_arr[1]}''"

	p.weight = weight_converter(res.weight)

	link = evo
  name = link.species.name.capitalize
  p.evolution = [name]
	while !link.evolves_to.first.nil?
		if link.evolves_to.length > 1
			link.evolves_to.each {|k|
				p.evolution << k.species.name.capitalize
			}
			link = link.evolves_to.first
		else
			link = link.evolves_to.first
			name = link.species.name.capitalize
			p.evolution << name
		end
	end

	p.save
end

