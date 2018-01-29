class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_common_instance_variables, only: [:show, :build_factory, :production, :import, :maneuver, :maneuver_destination, :taxation]

  def create
    pre_game = PreGame.find params[:pre_game_id]
    game = Game.new(pre_game_id: pre_game.id)
    if game.save
      investors = pre_game.users.map { |user| user.convert_users_to_investors(game) }
      game.update(investors: investors, current_country: game.countries.find_by(name: "austria_hungary"))
      game.start
      redirect_to game
    end
  end

  def show
    @current_investor = @game.investors.find_by(user: current_user)
    @available_steps = @game.get_rondel
  end

  def turn
    if params[:step] == "Production"
      redirect_to production_game_path
    elsif params[:step] == "Factory"
      redirect_to build_factory_game_path
    elsif params[:step] == "Import"
      redirect_to import_game_path
    elsif params[:step] == "Maneuver"
      redirect_to maneuver_game_path
    elsif params[:step] == "Taxation"
      redirect_to taxation_game_path
    end
  end

  def build_factory
    pieces = @game.regions.select do |region|
      region.pieces.length > 0
    end
    @pieces = pieces.map{ |region| region.name.downcase }
    if params[:region]
      @game.regions.find_by(name: params[:region]).update(has_factory: true)
      @game.current_country.update(money: @game.current_country.money - 5)
      @game.next_turn
      redirect_to game_path
    else
      regions = []
      Settings.countries.each do |country|
        if country[1].name == @game.current_country.name
          country[1].regions.each do |region|
            regions << region.name unless @game.regions.find_by(name: region.name).has_factory
          end
        end
      end
      @eligible_regions = regions
      render :build_factory
    end
  end

  def production
    regions_with_factories = @game.current_country.regions.select { |region| region.has_factory }
    regions_with_factories.each do |region|
      if region.factory_type == :armaments
        Army.create(region: region, country: region.country)
      else
        Fleet.create(region: region, country: region.country)
      end
    end
    @game.next_turn

    redirect_to game_path
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
    @game.pay_soldiers(@taxes)
  end

  private

  def set_common_instance_variables
    @game = Game.find(params[:id])
    @flags = @game.regions_with_flags
    @factories = @game.regions.where(has_factory: true).map do |country|
      "#{country.name}-factory"
    end
    @pieces = @game.regions_with_pieces
  end
end
