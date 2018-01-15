class Game < ApplicationRecord
  after_create :set_up_countries_and_regions
  after_create :set_up_neutral_regions
  after_create :set_up_sea_regions
  after_create :set_up_factories

  has_many :countries, dependent: :destroy
  has_many :regions, dependent: :destroy
  has_many :investors, dependent: :destroy
  belongs_to :current_country, :class_name => "Country", :foreign_key => "current_country_id", optional: true

  def start
    set_up_money
    set_up_bonds
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

  def set_up_bonds
    create_bonds
    distribute_initial_bonds
  end

  def create_bonds
    prices = [2, 4, 6, 9, 12, 16, 20, 25, 30]
    countries.each do |country|
      pairs = (1..9).zip(prices)
      pairs.each do |pair|
        Bond.create(price: pair[1], interest: pair[0], country: country)
      end
    end
  end

  def distribute_initial_bonds
    initial_bonds = Bond.where(country: countries, price: 9)

    initial_bonds.zip(investors.cycle) do |(bond, owner)|
      bond.update(investor: owner)
      owner.update(money: owner.money - bond.price)
      bond.country.update(money: bond.price)
    end
  end

  def get_rondel
    steps = TurnStep.new.get_steps
    unless current_country.regions.any? {|region| region.has_factory == false}
      steps[2][:enabled] = false
    end

    steps
  end

  def next_country
    {
      "austria_hungary": "italy",
      "italy": "france",
      "france": "england",
      "england": "germany",
      "germany": "russia",
      "russia": "austria_hungary"
    }
  end

  def regions_with_pieces
    regions_with_pieces = regions.map do |region|
      if region.pieces.length > 0
        region
      end
    end
    regions_with_pieces.compact
  end

  private

  def set_up_countries_and_regions
    Settings.countries.each do |country|
      new_country = Country.create(game_id: self.id, name: country[1].name)
      # self.update_attribute(current_country, new_country)
      country[1].regions.each do |region|
        new_country.regions << Region.create(game_id: self.id, name: region.name)
      end
    end
  end

  def set_up_neutral_regions
    Settings.neutrals.each do |region|
      Region.create(game_id: self.id, name: region.name)
    end
  end

  def set_up_sea_regions
    Settings.sea_regions.each do |region|
      Region.create(game_id: self.id, name: region.name, land: false)
    end
  end

  def set_up_factories
    Settings.starting_factories.armaments.each do |region_name|
      region = regions.find_by(name: region_name)
      region.update(has_factory: true)
    end

    Settings.starting_factories.shipyards.each do |region_name|
      region = regions.find_by(name: region_name)
      region.update(has_factory: true)
    end
  end
end
