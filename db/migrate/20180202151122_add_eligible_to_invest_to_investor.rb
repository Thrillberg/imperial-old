class AddEligibleToInvestToInvestor < ActiveRecord::Migration[5.1]
  def change
    add_column :investors, :eligible_to_invest, :boolean, default: false
  end
end
