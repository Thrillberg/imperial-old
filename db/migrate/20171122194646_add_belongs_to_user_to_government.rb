class AddBelongsToUserToGovernment < ActiveRecord::Migration[5.1]
  def change
    change_table :governments do |t|
      t.belongs_to :user, index: true
    end

    change_table :countries do |t|
      t.belongs_to :government, index: true, foreign_key: true
    end
  end
end
