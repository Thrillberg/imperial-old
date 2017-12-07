class Investor < ApplicationRecord
  has_many :bonds
  has_many :countries
  belongs_to :game
  belongs_to :user

  def countries
    game.countries.select do |country|
      country.owner == self
    end
  end
end
