class AddHasFactoryToRegion < ActiveRecord::Migration[5.1]
  def change
    add_column :regions, :has_factory, :boolean, default: false
  end
end
