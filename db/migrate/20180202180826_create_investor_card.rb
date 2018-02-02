class CreateInvestorCard < ActiveRecord::Migration[5.1]
  def change
    create_table :investor_cards do |t|
      t.belongs_to :game
      t.belongs_to :investor

      t.timestamps
    end
  end
end
