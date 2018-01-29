class AddScoreToCountry < ActiveRecord::Migration[5.1]
  def change
    add_column :countries, :score, :integer
  end
end
