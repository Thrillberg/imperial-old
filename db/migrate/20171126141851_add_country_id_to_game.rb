class AddCountryIdToGame < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :current_country_id, :integer
  end
end
