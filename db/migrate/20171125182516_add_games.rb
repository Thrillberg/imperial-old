class AddGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.timestamps
    end

    change_table :pre_games do |t|
      t.belongs_to :game
    end
  end
end
