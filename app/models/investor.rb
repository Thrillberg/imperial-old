class Investor < ApplicationRecord
  has_many :bonds
  belongs_to :game
  belongs_to :user

  def countries
    bonds.map do |bond|
      bond.country
    end
  end

  def next
    game.investors.where(seating_order: seating_order + 1).or(game.investors.where(seating_order: 0)).first
  end

  def has_investor_card?
    self == game.investor_card.investor
  end
end
