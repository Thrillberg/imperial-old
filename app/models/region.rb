class Region < ApplicationRecord
  has_and_belongs_to_many(
    :regions,
    :join_table => "region_neighbors",
    :foreign_key => "region_a_id",
    :association_foreign_key => "region_b_id"
  )
  has_many :pieces

  alias_attribute :neighbors, :regions
end
