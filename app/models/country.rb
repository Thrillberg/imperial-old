class Country < ApplicationRecord
  has_many :armies
  has_many :regions
end
