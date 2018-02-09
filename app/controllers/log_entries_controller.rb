class LogEntriesController < ApplicationController
  def index
    @game = Game.find(params[:game_id])
    @logs = @game.log_entries.reverse
  end
end
