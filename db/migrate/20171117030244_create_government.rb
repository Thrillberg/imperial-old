class CreateGovernment < ActiveRecord::Migration[5.1]
  def change
    create_table :governments do |t|
      t.belongs_to :game, index: true

      t.timestamps
    end
  end
end
