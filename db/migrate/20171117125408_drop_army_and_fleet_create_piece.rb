class DropArmyAndFleetCreatePiece < ActiveRecord::Migration[5.1]
  def change
    drop_table :armies
    drop_table :fleets

    create_table :pieces do |t|
      t.boolean :passive, default: false
      t.belongs_to :country, index: true
      t.belongs_to :region, index: true

      t.timestamps
    end
  end
end
