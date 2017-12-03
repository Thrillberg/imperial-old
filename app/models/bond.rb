class Bond < ApplicationRecord
  belongs_to :country
  belongs_to :investor, optional: true
end
