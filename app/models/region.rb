class Region < ApplicationRecord
  has_many :pieces
  has_one :flag
  belongs_to :game
  belongs_to :country, optional: true

  def factory_type
    if Settings.factories.armaments.include? name
      return :armaments
    elsif Settings.factories.shipyards.include? name
      return :shipyard
    end
  end

  def neighbors
    Settings.neighbors[self.name].map do |neighbor|
      Region.find_by(name: neighbor)
    end
  end
end
