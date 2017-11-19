class Country < ApplicationRecord
  has_many :armies, dependent: :destroy
  has_many :regions, dependent: :destroy
end
