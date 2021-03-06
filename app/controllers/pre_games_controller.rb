class PreGamesController < ApplicationController
  before_action :authenticate_user!

  def index
    @joinable_games = PreGame.all.reject(&:started?)
    @pre_game = PreGame.new
    @users = User.all
    @games = Game.all
  end

  def create
    @pre_game = PreGame.new(users: [current_user], creator: current_user)
    if @pre_game.save
      warden = request.env["warden"]
      PreGameCreateBroadcastJob.perform_now(@pre_game, warden)
      redirect_to @pre_game
    end
  end

  def show
    @pre_game = PreGame.find(params[:id])
    @game = @pre_game.game
    @start_enabled = @pre_game.users.count > 1 &&
      current_user == @pre_game.creator
    if @pre_game.started?
      @current_investor = @game.investors.find_by(user: current_user)
      redirect_to game_investor_path(game_id: @game.id, id: @current_investor.id)
    end
  end

  def update
    pre_game = PreGame.find(params[:id])
    if pre_game.users.include? current_user
      pre_game.users.delete(current_user)
      PreGamePopulateBroadcastJob.perform_now(current_user, pre_game.id, "leave")
      if pre_game.users.count == 0
        pre_game.destroy
      end
    else
      pre_game.users << current_user
      PreGamePopulateBroadcastJob.perform_now(current_user, pre_game.id, "join")
      redirect_to pre_game
    end
  end
end
