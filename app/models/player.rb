class Player < ApplicationRecord
  has_many :countries
  belongs_to :game
  belongs_to :user
end
