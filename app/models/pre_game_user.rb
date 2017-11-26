class PreGameUser < ApplicationRecord
  belongs_to :user
  belongs_to :pre_game
end
