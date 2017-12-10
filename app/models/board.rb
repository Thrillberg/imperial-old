class Board < ApplicationRecord
  has_many :regions
  belongs_to :game
end
