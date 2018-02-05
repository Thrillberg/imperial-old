class InvestorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_common_instance_variables, only: [:show, :build_factory, :import, :maneuver, :maneuver_destination, :investor_turn, :turn]

  def show
    if @current_investor.eligible_to_invest
      @available_bonds = @game.bonds.where(investor: nil)
      render :investor_turn
    end
    if params[:in_turn]
      case @current_country.step
      when /^maneuver/i
        session[:moved_pieces_ids] ||= []
        @eligible_regions = helpers.eligible_regions(@current_country.step)
        render :maneuver
      when /^production/i
        @game.production
        @game.next_turn
        redirect_to game_investor_path
      when /^factory/i
        render :build_factory
      when /^import/i
        render :import
      when /^investor/i
        @game.pay_interest
        @game.activate_investor
        if @current_investor.has_investor_card?
          render :investor_turn
        else
          eligible_investor = @game.investor_card.investor
          eligible_investor.update(eligible_to_invest: true)
          EligibleToInvestBroadcastJob.perform_now(@game.id, eligible_investor.id, eligible_investor.user.id)
          render :wait_for_investors
        end
      when /^taxation/i
        @taxes = @game.get_taxes
        @power_position = @game.move_on_tax_chart(@taxes)
        @game.add_power_points
        @game.next_turn
        redirect_to game_investor_path
      end
    end
  end

  def build_factory
    if params[:region]
      @game.regions.find_by(name: params[:region]).update(has_factory: true)
      @current_country.update(money: @current_country.money - 5)
      @game.next_turn
      redirect_to game_investor_path
    end
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

        redirect_to game_investor_path and return
      end

      session[:import_count] = @import_count
      redirect_back(fallback_location: game_investor_path)
    end
  end

  def maneuver
    session[:moved_pieces_ids] ||= []

    if (params[:origin_region])
      redirect_to maneuver_destination_game_investor_path(origin_region: params[:origin_region])
    end
  end

  def maneuver_destination
    if params[:destination_region]
      origin_region = @game.regions.find_by(name: params[:origin_region])
      destination_region = @game.regions.find_by(name: params[:destination_region])
      piece = origin_region.pieces.where(country: @current_country).take
      piece.update(region: destination_region)
      @game.check_for_conflict(piece)
      @game.reconcile_flags(destination_region)
      session[:moved_pieces_ids] << piece.id
      if (@current_country.pieces.map(&:id) - session[:moved_pieces_ids]).empty?
        session[:moved_pieces_ids] = []
        @game.next_turn

        redirect_to game_investor_path
      else
        redirect_to maneuver_game_investor_path
      end
    elsif params[:origin_region]
      @eligible_regions = helpers.eligible_regions(:maneuver_destination, params)
      session[:origin_region] = params[:origin_region]
    end

    if params[:next_turn]
      session[:moved_pieces_ids] = []
      @game.next_turn
      redirect_to game_investor_path
    end
  end

  def investor_turn
    @available_bonds = @game.bonds.where(investor: nil)
    if params[:bond]
      PurchasedBondBroadcastJob.perform_now(@game.id, @current_investor.id, params[:bond])
      @game.purchase_bond(params[:bond], @current_investor)
      @game.investor_card.pass_card
      @current_investor.update(eligible_to_invest: false)
      @game.next_turn
      redirect_to game_investor_path
    end
  end

  def wait_for_investors
  end

  def turn
    @current_country.update step: params[:step]

    redirect_to game_investor_path(in_turn: true)
  end

  private

  def set_common_instance_variables
    @game = Game.find(params[:game_id])
    @flags = @game.regions_with_flags
    @current_country = @game.current_country
    @factories = @game.regions.where(has_factory: true).map do |country|
      "#{country.name}-factory"
    end
    @pieces = @game.regions_with_pieces
    @current_investor = @game.investors.find_by(user: current_user)
    rondel = Rondel.new current_action: @current_country.step
    @steps = rondel.available
    @country_steps = @game.countries.map do |country|
      {
        name: country.name,
        step: country.step,
        color: Settings.countries[country.name].color
      }
    end
  end
end
