class AddPositionOnTaxChartToCountry < ActiveRecord::Migration[5.1]
  def change
    add_column :countries, :position_on_tax_chart, :string
  end
end
