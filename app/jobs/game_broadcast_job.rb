class GameBroadcastJob < ApplicationJob
  queue_as :default

  def perform(game)
    ActionCable.server.broadcast 'games_channel', game: render_game(game)
  end

  private

  def render_game(game)
    ApplicationController.renderer.render(partial: 'games/game', locals: { game: game })
  end
end
