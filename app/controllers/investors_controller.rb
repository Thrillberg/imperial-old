class InvestorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_common_instance_variables, only: [:show, :build_factory, :production, :import, :maneuver, :maneuver_destination, :taxation, :investor]

  def show
    rondel = Rondel.new current_action: @game.current_country.step
    @steps = rondel.available
  end

  def turn
    id = params[:game_id]
    game = Game.find id
    country = game.current_country
    country.update step: params[:step]

    case params[:step].to_s
    when /^maneuver/i
      redirect_to maneuver_game_path(id: id)
    when /^production/i
      redirect_to production_game_path(id: id)
    when /^factory/i
      redirect_to build_factory_game_path(id: id)
    when /^import/i
      redirect_to import_game_path(id: id)
    when /^investor/i
      redirect_to investor_game_path(id: id)
    when /^taxation/i
      redirect_to taxation_game_path(id: id)
    end
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
