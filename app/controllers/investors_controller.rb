class InvestorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_common_instance_variables, only: [:show, :build_factory, :production, :import, :maneuver, :maneuver_destination, :taxation, :investor]

  def show
    if params[:in_turn]
      case @game.current_country.step
      when /^maneuver/i
      when /^production/i
        @game.current_country.regions.select(&:has_factory).each do |region|
          if region.factory_type == :armaments
            Army.create(region: region, country: region.country)
          else
            Fleet.create(region: region, country: region.country)
          end
        end
        @game.next_turn

        redirect_to game_investor_path
      when /^factory/i
        regions = []
        @game.current_country.regions.each do |region|
          regions << region.name unless @game.regions.find_by(name: region.name).has_factory
        end
        @eligible_regions = regions

        render :build_factory
      when /^import/i
        redirect_to import_game_path(id: id)
      when /^investor/i
        redirect_to investor_game_path(id: id)
      when /^taxation/i
        redirect_to taxation_game_path(id: id)
      end
    else
      rondel = Rondel.new current_action: @game.current_country.step
      @steps = rondel.available
    end
  end

  def build_factory
    if params[:region]
      @game.regions.find_by(name: params[:region]).update(has_factory: true)
      @game.current_country.update(money: @game.current_country.money - 5)
      @game.next_turn
      redirect_to game_investor_path
    end
  end

  def turn
    id = params[:game_id]
    game = Game.find id
    country = game.current_country
    country.update step: params[:step]

    redirect_to game_investor_path(in_turn: true)
  end

  private

  def set_common_instance_variables
    @game = Game.find(params[:game_id])
    @flags = @game.regions_with_flags
    @factories = @game.regions.where(has_factory: true).map do |country|
      "#{country.name}-factory"
    end
    @pieces = @game.regions_with_pieces
    @current_investor = @game.investors.find_by(user: current_user)
  end
end
