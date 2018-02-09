class CreateLogEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :log_entries do |t|
      t.string :action
      t.belongs_to :country
      t.belongs_to :game

      t.timestamps
    end
  end
end
