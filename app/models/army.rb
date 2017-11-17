class Army < ApplicationRecord
  belongs_to :country
  belongs_to :region
end
