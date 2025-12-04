class CreateArtists < ActiveRecord::Migration[8.0]
  def change
    create_table :artists do |t|
      t.string :name
      t.integer :age
      t.integer :experience_level

      t.timestamps
    end
  end
end
