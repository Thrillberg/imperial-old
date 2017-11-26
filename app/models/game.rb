class Game < ApplicationRecord
  before_save :add_board
  after_create :set_up_countries_and_regions
  after_create :set_up_neutral_regions
  after_create :set_up_sea_regions
  after_create :set_up_factories

  has_one :board, dependent: :destroy
  has_many :countries, dependent: :destroy
  belongs_to :current_country, :class_name => "Country", :foreign_key => "country_id", optional: true
  has_many :users
  has_many :investors, dependent: :destroy

  def start
    assign_investors_to_countries
    # assign_users_to_investors
    set_up_money
  end

  def assign_investors_to_countries
    countries.zip(investors.cycle) do |pair|
      pair[0].investor = pair[1]
      pair[0].save
    end
  end

  def assign_users_to_investors
    users.zip(investors) do |pair|
      pair[0].investors << pair[1]
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
    money = amounts[investors.count].to_i
    investors.each do |investor|
      investor.update(money: money)
    end
  end

  def get_rondel
    TurnStep.new.get_steps
  end

  private

  def turn_order
    ["Austria-Hungary", "Italy", "France", "England", "Germany", "Russia"]
  end

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
