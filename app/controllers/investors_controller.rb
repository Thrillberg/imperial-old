class InvestorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_common_instance_variables, only: [:show, :build_factory, :production, :import, :maneuver, :maneuver_destination, :taxation, :investor]

  def show
    @available_steps = @game.get_rondel
  end

  def turn
    id = params[:game_id]
    if params[:step] == "Production"
      redirect_to production_game_path(id: id)
    elsif params[:step] == "Factory"
      redirect_to build_factory_game_path(id: id)
    elsif params[:step] == "Import"
      redirect_to import_game_path(id: id)
    elsif params[:step] == "Maneuver"
      redirect_to maneuver_game_path(id: id)
    elsif params[:step] == "Taxation"
      redirect_to taxation_game_path(id: id)
    elsif params[:step] == "Investor"
      redirect_to investor_game_path(id: id)
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
