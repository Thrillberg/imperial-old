class Game < ApplicationRecord
  include TaxationStep
  include InvestorStep
  include ProductionStep

  after_create :set_up_countries_and_regions
  after_create :set_up_neutral_regions
  after_create :set_up_sea_regions
  after_create :set_up_factories

  has_many :countries, dependent: :destroy
  has_many :regions, dependent: :destroy
  has_many :investors, dependent: :destroy
  has_one :investor_card
  has_many :bonds, dependent: :destroy
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
        Bond.create(price: pair[1], interest: pair[0], country: country, game: self)
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

  def next_turn
    self.update(current_country: self.countries.find_by(name: self.next_country[self.current_country.name.to_sym]))
  end

  def check_for_conflict(moving_piece)
    pieces = moving_piece.region.pieces
    enemy_piece = pieces.where.not(country: moving_piece.country)
      if enemy_piece.count > 0
      Piece.destroy(enemy_piece[0].id)
      Piece.destroy(moving_piece.id)
    end
  end

  def reconcile_flags(region)
    if region.pieces.count > 0 && !region.country
      region.flag.destroy if region.flag
      Flag.create(region: region, country: region.pieces.first.country)
    end
  end

  def regions_with_pieces
    regions_with_pieces = regions.map do |region|
      if region.pieces.length > 0
        region.pieces.map do |piece|
          {
            region_name: piece.region.name,
            country_name: piece.country.name,
            type: piece.type.downcase,
            color: Settings.countries[piece.country.name].color,
            font_color: Settings.countries[piece.country.name].font_color
          }
        end
      end
    end
    regions_with_pieces.compact.flatten
  end

  def regions_with_flags
    regions.map(&:flag).compact.map do |flag|
      {
        color: Settings.countries[flag.country.name].color,
        region_name: Region.find(flag.region.id).name
      }
    end
  end

  def establish_investor_order
    investors.shuffle.each_with_index do |investor, index|
      investor.update(seating_order: index)
    end
  end

  private

  def set_up_countries_and_regions
    Settings.countries.each do |country|
      new_country = Country.create(game_id: self.id, name: country[1].name, position_on_tax_chart: Settings.tax_chart[0], score: 0)
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
