class GamesController < ApplicationController
  before_action :authenticate_user!

  def index
    @games = Game.all
    @game = Game.new
    @users = User.all
  end

  def create
    @game = Game.new(users: [current_user])
    if @game.save
      warden = request.env["warden"]
      GameBroadcastJob.perform_now(@game, warden)
      redirect_to @game
    end
  end

  def show
    @game = Game.find(params[:id])
    @countries = @game.countries
  end

  def update
    game = Game.find(params[:id])
    user = User.find(params[:user_id])
    if game.users.include? user
      game.users.delete(user)
    else
      game.users << user
      redirect_to game
    end
  end
end
