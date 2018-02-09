class Country < ApplicationRecord
  after_create :set_up_bonds
  after_create :set_up_regions

  has_many :pieces, dependent: :destroy
  has_many :regions, dependent: :destroy
  has_many :bonds
  has_many :flags
  has_many :log_entries
  belongs_to :game, optional: true

  def set_up_bonds
    prices = [2, 4, 6, 9, 12, 16, 20, 25, 30]
    pairs = (1..9).zip(prices)
    pairs.each do |pair|
      Bond.create(price: pair[1], interest: pair[0], country: self, game: game)
    end
  end

  def set_up_regions
    Settings.countries[name].regions.each do |region|
      regions << Region.create(game_id: game.id, name: region.name)
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
