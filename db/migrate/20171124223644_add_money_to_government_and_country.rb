class AddMoneyToGovernmentAndCountry < ActiveRecord::Migration[5.1]
  def change
    add_column :countries, :money, :integer
    add_column :investors, :money, :integer
  end
end
