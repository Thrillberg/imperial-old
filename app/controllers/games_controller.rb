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
  end

  def build_factory
    @game = Game.find(params[:id])
    if params[:region]
      @game.regions.find_by(name: params[:region]).update(has_factory: true)
      redirect_to game_path
    else
      @factories = @game.regions.where(has_factory: true).map do |country|
        "#{country.name.downcase}-factory"
      end
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
end
