class GamesController < ApplicationController
  def create
    pre_game = PreGame.find params[:pre_game_id]
    game = pre_game.game
    game.update(users: pre_game.users)
    game.start
    redirect_to game
  end

  def show
    @game = Game.find(params[:id])
    @countries = @game.countries
    @current_investor = @game.investors.find_by(user: current_user.id)
  end
end
