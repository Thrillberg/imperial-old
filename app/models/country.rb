class Country < ApplicationRecord
  has_many :armies, dependent: :destroy
  has_many :regions, dependent: :destroy
  belongs_to :government, optional: true
end
