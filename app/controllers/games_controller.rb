class GamesController < ApplicationController
  before_action :authenticate_user!

  def index
    @games = Game.all
    @game = Game.new
    @users = User.all
  end

  def create
    ActionCable.server.broadcast 'games',
      game: @game
    head :ok
  end

  def show
    @game = Game.find(params[:id])
    @countries = @game.countries
  end
end
