class GamesController < ApplicationController
  def create
    pre_game = PreGame.find create_params[:pre_game_id]
    game = Game.create(pre_game: pre_game)
    redirect_to game
  end

  def show
    @game = Game.find(params[:id])
    @countries = @game.countries
  end

  def create_params
    params.require(:game).permit(:pre_game_id)
  end
end
