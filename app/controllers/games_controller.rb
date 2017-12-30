class GamesController < ApplicationController
  before_action :authenticate_user!

  def create
    pre_game = PreGame.find params[:pre_game_id]
    game = Game.new(pre_game_id: pre_game.id)
    if game.save
      investors = pre_game.users.map { |user| user.convert_users_to_investors(game) }
      game.update(investors: investors, current_country: game.countries.find_by(name: "Austria-Hungary"))
      game.start
      redirect_to game
    end
  end

  def show
    @game = Game.find(params[:id])
    @countries = @game.countries
    @investors = @game.investors
    @current_investor = @investors.find_by(user: current_user.id)
    @factories = @game.regions.where(has_factory: true).map do |country|
      "#{country.name.downcase}-factory"
    end
    @flags = {
      "Austria-Hungary": "austro_hungarian_flag",
      "France": "french_flag",
      "Germany": "german_flag",
      "Russia": "russian_flag",
      "Italy": "italian_flag",
      "England": "uk_flag"
    }
    @meeples = {
      "Austria-Hungary": "austria_hungary_meeple",
      "France": "france_meeple",
      "Germany": "germany_meeple",
      "Russia": "russia_meeple",
      "Italy": "italy_meeple",
      "England": "uk_meeple"
    }
    @step = params[:step]
  end

  def update
    @game = Game.find(clean_params[:id])
    step = clean_params[:step]
    region_id = clean_params[:region]
    if step
      take_step(@game, step)
    elsif region_id
      build_factory(@game, Region.find(region_id))
      @game.update(current_country: @game.countries.find_by(name: @game.next_country[@game.current_country.name.to_sym]))
    end
  end

  def take_step(game, step)
    @current_country = game.current_country
    @current_country.take_turn(step)
    @current_country.update(step: step)
    redirect_to game_path(game: game, step: step)
  end

  def build_factory(game, region)
    region.update(has_factory: true)
    redirect_to :action =>:show, :game => game
  end

  def clean_params
    params.require(:game).permit(:step, :region, :id)
  end
end
