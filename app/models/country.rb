class Country < ApplicationRecord
  has_many :pieces, dependent: :destroy
  has_many :regions, dependent: :destroy
  has_many :bonds
  has_many :flags
  belongs_to :game, optional: true

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
