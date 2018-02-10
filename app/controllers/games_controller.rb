class GamesController < ApplicationController
  before_action :authenticate_user!

  def create
    pre_game = PreGame.find(params[:pre_game_id])
    game = pre_game.build_game
    if game.save
      pre_game.users.map { |user| user.investors.create(game: game) }
      game.start
      redirect_to game
    end
  end

  def show
    @game = Game.find(params[:id])
    @current_investor = @game.investors.find_by(user: current_user)
    redirect_to game_investor_path(game_id: @game.id, id: @current_investor.id)
  end
end
