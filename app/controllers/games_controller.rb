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
  end

  def update
    @game = Game.find(clean_params[:id])
    @current_country = @game.current_country
    @current_country.take_turn(clean_params[:step])
    @current_country.update(step: clean_params[:step])
    @game.update(current_country: @game.countries.find_by(name: @game.next_country[@current_country.name.to_sym]))
    render "shared/_#{clean_params[:step]}"
  end

  def clean_params
    params.require(:game).permit(:step, :id)
  end
end
