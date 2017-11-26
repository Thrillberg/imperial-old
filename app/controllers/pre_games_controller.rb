class PreGamesController < ApplicationController
  before_action :authenticate_user!

  def index
    @pre_games = PreGame.all
    @pre_game = PreGame.new
    @users = User.all
  end

  def create
    @pre_game = PreGame.new(users: [current_user], game: Game.new, creator: current_user)
    if @pre_game.save
      warden = request.env["warden"]
      PreGameBroadcastJob.perform_now(@pre_game, warden)
      redirect_to @pre_game
    end
  end

  def show
    @pre_game = PreGame.find(params[:id])
    @start_enabled = @pre_game.users.count > 1 &&
      current_user == @pre_game.creator
  end

  def update
    pre_game = PreGame.find(params[:id])
    user = User.find(params[:user_id])
    if pre_game.users.include? user
      pre_game.users.delete(user)
      if pre_game.users.count == 0
        pre_game.destroy
      end
    else
      pre_game.users << user
      redirect_to pre_game
    end
  end

  def destroy
    pre_game = PreGame.find(params[:id])
    game = pre_game.game
    game.start(pre_game)
    if game.save
      pre_game.destroy
      redirect_to game
    end
  end
end
