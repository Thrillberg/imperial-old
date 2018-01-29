class CreateBonds < ActiveRecord::Migration[5.1]
  def change
    create_table :bonds do |t|
      t.integer :price
      t.integer :interest
      t.belongs_to :country, index: true
      t.belongs_to :investor, index: true
      t.belongs_to :game, index: true

      t.timestamps
    end
  end
end
