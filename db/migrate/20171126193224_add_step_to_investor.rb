class AddStepToInvestor < ActiveRecord::Migration[5.1]
  def change
    add_column :investors, :step, :string
  end
end
