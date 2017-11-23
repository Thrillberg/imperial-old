class GamesController < ApplicationController
  before_action :authenticate_user!

  def index
    @games = Game.all
    @game = Game.new
  end

  def create
    # @game = Game.new
    # if @game.save
      ActionCable.server.broadcast 'games',
        game: @game
      head :ok
    # end
  end

  def show
    @game = Game.find(params[:id])
    @countries = @game.countries
  end
end
