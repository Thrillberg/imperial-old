class AddFlags < ActiveRecord::Migration[5.1]
  def change
    create_table :flags do |t|
      t.belongs_to :country, index: true
      t.belongs_to :region, index: true

      t.timestamps
    end
  end
end
