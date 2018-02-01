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

  def import
    if params[:region]
      region = @game.regions.find_by(name: params[:region])
      Army.create(region: region, country: region.country)
      region.country.update(money: region.country.money - 1)
      @import_count = params[:import_count]

      if @import_count.to_i >= 3
        @game.next_turn
        session[:import_count] = 0

        redirect_to game_path and return
      end

      session[:import_count] = @import_count
      redirect_back(fallback_location: game_path)
    else
      @eligible_regions = @game.current_country.regions.map(&:name)

      render :import
    end
  end

  def maneuver
    if (params[:origin_region])
      redirect_to maneuver_destination_game_path(origin_region: params[:origin_region])
    else
      session[:moved_pieces_ids] ||= []
      eligible_pieces = @game.current_country.pieces.reject{|piece| session[:moved_pieces_ids].include? piece.id}
      @eligible_regions = eligible_pieces.map(&:region).map(&:name)
    end
  end

  def maneuver_destination
    if params[:destination_region]
      origin_region = @game.regions.find_by(name: params[:origin_region])
      destination_region = @game.regions.find_by(name: params[:destination_region])
      piece = origin_region.pieces.where(country: @game.current_country).take
      piece.update(region: destination_region)
      @game.check_for_conflict(piece)
      @game.reconcile_flags(destination_region)
      session[:moved_pieces_ids] << piece.id
      if (@game.current_country.pieces.map(&:id) - session[:moved_pieces_ids]).empty?
        session[:moved_pieces_ids] = []
        @game.next_turn

        redirect_to game_path
      else
        redirect_to maneuver_game_path, origin_region: nil, destination_region: nil
      end
    elsif params[:origin_region]
      @eligible_regions = Settings.neighbors[params[:origin_region]]
      session[:origin_region] = params[:origin_region]
    end

    if params[:next_turn]
      session[:moved_pieces_ids] = []
      @game.next_turn
      redirect_to game_path
    end
  end

  def taxation
    @taxes = @game.get_taxes
    @power_position = @game.move_on_tax_chart(@taxes)
    @game.add_power_points
    @game.next_turn

    redirect_to game_path
  end

  def investor_turn
    if params[:bond]
      @game.purchase_bond(params[:bond])
      @game.pass_investor_card
      @game.next_turn
      redirect_to game_path
    else
      @game.pay_interest
      @game.activate_investor
      @available_bonds = @game.bonds.where(investor: nil)
      render :investor_turn
    end
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
