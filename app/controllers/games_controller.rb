class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_common_instance_variables, only: [:show, :build_factory, :production, :import, :maneuver, :maneuver_destination, :taxation, :investor]

  def create
    pre_game = PreGame.find params[:pre_game_id]
    game = Game.new(pre_game_id: pre_game.id)
    if game.save
      austria_hungary = game.countries.find_by(name: "austria_hungary")
      investors = pre_game.users.map { |user| user.convert_users_to_investors(game) }
      game.establish_investor_order
      eligible_investors = investors.reject { |investor| investor.countries.include? austria_hungary }
      eligible_investors.sample.update(has_investor_card: true)
      game.update(investors: investors, current_country: austria_hungary)
      game.start
      redirect_to game
    end
  end

  def show
    redirect_to game_investor_path(game_id: @game.id, id: @current_investor.id)
  end

  def taxation
    @taxes = @game.get_taxes
    @power_position = @game.move_on_tax_chart(@taxes)
    @game.add_power_points
    @game.next_turn

    redirect_to game_path
  end

  private

  def set_common_instance_variables
    @game = Game.find(params[:id])
    @flags = @game.regions_with_flags
    @factories = @game.regions.where(has_factory: true).map do |country|
      "#{country.name}-factory"
    end
    @pieces = @game.regions_with_pieces
    @current_investor = @game.investors.find_by(user: current_user)
  end
end
