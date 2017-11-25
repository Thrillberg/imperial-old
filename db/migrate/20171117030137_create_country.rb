class CreateCountry < ActiveRecord::Migration[5.1]
  def change
    create_table :countries do |t|
      t.string :name
      t.belongs_to :pre_game, index: true

      t.timestamps
    end
  end
end
