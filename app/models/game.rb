class Game < ApplicationRecord
  before_create :add_board
  after_create :set_up_countries_and_regions
  after_create :set_up_neutral_regions
  after_create :set_up_sea_regions
  after_create :set_up_neighbor_regions
  after_create :set_up_factories

  has_one :board, dependent: :destroy
  has_many :countries, dependent: :destroy
  has_many :players, dependent: :destroy
  has_many :users, through: :players

  def start
    assign_players_to_countries
    assign_users_to_players
    set_up_money
  end

  def assign_users_to_players
    users.zip(players) do |pair|
      pair[0].players << pair[1]
    end
  end

  def assign_players_to_countries
    countries.zip(players.cycle) do |pair|
      pair[0].player = pair[1]
      pair[0].save
    end
  end

  def set_up_money
    amounts = {
      2 => '35',
      3 => '24',
      4 => '13',
      5 => '13',
      6 => '13',
    }
    money = amounts[players.count].to_i
    players.each do |player|
      player.update(money: money)
    end
  end

  def get_users
    users_string = ''
    users.each do |user|
      users_string << user.username + ', '
    end
    users_string.chomp(', ') if users_string != ''
  end

  private

  def add_board
    self.board = Board.create
  end

  def set_up_countries_and_regions
    Settings.countries.each do |country|
      new_country = Country.create(game_id: self.id, name: country[1].name)
      country[1].regions.each do |region|
        new_country.regions << Region.create(name: region)
      end
    end
  end

  def set_up_neutral_regions
    Settings.neutrals.each do |region|
      Region.create(name: region)
    end
  end

  def set_up_sea_regions
    Settings.sea_regions.each do |region|
      Region.create(name: region, land: false)
    end
  end

  def set_up_neighbor_regions
    Settings.neighbors.each do |region_data|
      region_data[1].each do |neighbor_name|
        region = Region.find_by(name: region_data[0].to_s)
        neighbor = Region.find_by(name: neighbor_name)
        region.neighbors << neighbor
      end
    end
  end

  def set_up_factories
    Settings.factories.armaments.each do |region_name|
      region = Region.find_by(name: region_name)
      region.has_factory = true
      region.save
    end

    Settings.factories.shipyards.each do |region_name|
      region = Region.find_by(name: region_name)
      region.has_factory = true
      region.save
    end
  end
end
