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
    Investor.where(seating_order: seating_order + 1).or(Investor.where(seating_order: 0))
  end
end
