class CreateRegionNeighbors < ActiveRecord::Migration[5.1]
  def change
    create_table :region_neighbors, id: false do |t|
      t.integer :region_a_id, null: false
      t.integer :region_b_id, null: false
    end
  end
end
