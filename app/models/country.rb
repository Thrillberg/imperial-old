class Country < ApplicationRecord
  has_many :armies, dependent: :destroy
  has_many :regions, dependent: :destroy
  has_many :bonds
  belongs_to :game

  def take_turn(step)
    case step
    when "Factory"
      FactoryStep.execute(self)
    end
  end

  def owner
    hash = Hash.new(0)
    bonds.each  do |bond|
      if bond.investor_id
        hash[bond.investor_id] += bond.price if bond.investor_id
      end
    end
    owner_id, = hash.max_by { |id, investment| investment }
    Investor.find(owner_id)
  end
end
