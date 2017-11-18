class CreateRegion < ActiveRecord::Migration[5.1]
  def change
    create_table :regions do |t|
      t.string :name
      t.boolean :land, default: true
      t.belongs_to :country, index: true

      t.timestamps
    end
  end
end
