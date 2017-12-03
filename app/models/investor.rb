class Investor < ApplicationRecord
  has_many :bonds
  has_many :countries, through: :bonds
  belongs_to :game
  belongs_to :user
end
