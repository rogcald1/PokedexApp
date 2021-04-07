class CreatePokemons < ActiveRecord::Migration[6.1]
  def change
    create_table :pokemons do |t|
      t.integer :poke_id
      t.string :name
      t.string :category
      t.string :description
      t.text :types, array: true
      t.text :evolution, array: true
      t.string :height
      t.string :weight
      t.text :abilities, array: true

      t.timestamps
    end
  end
end
