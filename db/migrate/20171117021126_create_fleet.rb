class CreateFleet < ActiveRecord::Migration[5.1]
  def change
    create_table :fleets do |t|
      t.boolean :passive, default: false
      t.belongs_to :country, index: true
      t.belongs_to :region, index: true

      t.timestamps
    end
  end
end
