class GamesController < ApplicationController
  def create
    pre_game = PreGame.find params[:pre_game_id]
    game = Game.new
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
    @current_investor = @game.investors.find_by(user: current_user.id)
  end
end
