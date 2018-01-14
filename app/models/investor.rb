class Investor < ApplicationRecord
  has_many :bonds
  belongs_to :game
  belongs_to :user

  def countries
    bonds.map do |bond|
      bond.country
    end
  end
end
