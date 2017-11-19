class GamesController < ApplicationController
  def index
    @games = Game.all
    @game = Game.new
  end

  def create
    @game = Game.new
    if @game.save
      redirect_to @game
    end
  end

  def show
    @game = Game.find(params[:id])
    @countries = @game.countries
  end
end
