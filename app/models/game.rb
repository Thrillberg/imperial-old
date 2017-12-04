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
  has_one :pre_game

  def start
    assign_bonds_to_investors
    # assign_users_to_investors
  end

  def assign_bonds_to_investors
    set_up_money
    set_up_bonds
  end

  # def assign_users_to_investors
  #   users.zip(investors) do |pair|
  #     pair[0].investors << pair[1]
  #   end
  # end

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
    TurnStep.new.get_steps
  end

  def next_country
    {
      "Austria-Hungary": "Italy",
      "Italy": "France",
      "France": "England",
      "England": "Germany",
      "Germany": "Russia",
      "Russia": "Austria_Hungary"
    }
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

  def set_up_factories
    Settings.starting_factories.armaments.each do |region_name|
      region = Region.find_by(name: region_name)
      region.update(has_factory: true)
    end

    Settings.starting_factories.shipyards.each do |region_name|
      region = Region.find_by(name: region_name)
      region.update(has_factory: true)
    end
  end
end
