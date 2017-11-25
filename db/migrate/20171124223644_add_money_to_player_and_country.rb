class AddMoneyToPlayerAndCountry < ActiveRecord::Migration[5.1]
  def change
    add_column :countries, :money, :integer
    add_column :players, :money, :integer
  end
end
