class Game < ApplicationRecord
  include TaxationStep
  include InvestorStep
  include ProductionStep

  after_create :set_up_countries
  after_create :set_up_neutral_regions
  after_create :set_up_sea_regions
  after_create :set_up_factories

  has_many :countries, dependent: :destroy
  has_many :regions, dependent: :destroy
  has_many :investors, dependent: :destroy
  has_one :investor_card
  has_many :bonds, dependent: :destroy
  has_many :log_entries
  belongs_to :current_country, :class_name => "Country", :foreign_key => "current_country_id", optional: true

  def start
    set_up_money
    distribute_initial_bonds
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
    update(current_country: countries.find_by(name: next_country[current_country.name.to_sym]))
    NextTurnBroadcastJob.perform_now(id)
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

  def build_factory(region_name)
    regions.find_by(name: region_name).update(has_factory: true)
    current_country.update(money: current_country.money - 5)
    next_turn
  end

  def import(region_name)
    region = regions.find_by(name: region_name)
    country = region.country
    Army.create(region: region, country: country)
    country.update(money: country.money - 1)
  end

  private

  def set_up_countries
    Settings.countries.each do |country|
      Country.create(game_id: self.id, name: country[1].name, position_on_tax_chart: Settings.tax_chart[0], score: 0)
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
