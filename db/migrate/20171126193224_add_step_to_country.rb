class AddStepToCountry < ActiveRecord::Migration[5.1]
  def change
    add_column :countries, :step, :string
  end
end
