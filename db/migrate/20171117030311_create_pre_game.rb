class CreatePreGame < ActiveRecord::Migration[5.1]
  def change
    create_table :pre_games do |t|

      t.timestamps
    end
  end
end
