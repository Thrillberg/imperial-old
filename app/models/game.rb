class Game < ApplicationRecord
  before_create :add_board
  after_create :set_board_spaces

  has_one :board, dependent: :destroy
  has_many :players, dependent: :destroy
  has_many :countries, dependent: :destroy

  private

  def add_board
    self.board = Board.create
  end

  def set_board_spaces
    Settings.countries.each do |country|
      new_country = Country.create(game_id: self.id, name: country[1].name)
      country[1].regions.each do |region|
        new_country.regions << Region.create(name: region)
      end
    end

    Settings.neutrals.each do |region|
      Region.create(name: region)
    end

    Settings.sea_regions.each do |region|
      Region.create(name: region, land: false)
    end

    Settings.neighbors.each do |region_data|
      region_data[1].each do |neighbor_name|
        region = Region.find_by(name: region_data[0].to_s)
        neighbor = Region.find_by(name: neighbor_name)
        region.neighbors << neighbor
      end
    end
  end
end
