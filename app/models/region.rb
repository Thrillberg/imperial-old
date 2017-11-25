class Region < ApplicationRecord
  has_many :pieces

  def neighbors
    Settings.neighbors[self.name].map do |neighbor|
      Region.find_by(name: neighbor)
    end
  end
end
