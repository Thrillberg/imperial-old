class CreatePreGameUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :pre_game_users do |t|
      t.belongs_to :pre_game, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
