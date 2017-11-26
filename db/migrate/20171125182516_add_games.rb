class AddGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.belongs_to :pre_game, index: true
      t.timestamps
    end
  end
end
