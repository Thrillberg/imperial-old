class Player < ApplicationRecord
  has_many :countries
  belongs_to :pre_game
  belongs_to :user
end
