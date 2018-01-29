class AddHasInvestorCardToInvestor < ActiveRecord::Migration[5.1]
  def change
    add_column :investors, :has_investor_card, :boolean
    add_column :investors, :seating_order, :integer
  end
end
