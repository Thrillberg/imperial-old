class GameBroadcastJob < ApplicationJob
  queue_as :default

  def perform(game, warden)
    renderer = ApplicationController.renderer.new
    renderer.instance_variable_set(:@env, {
      "HTTP_HOST"=>"localhost:3000",
      "HTTPS"=>"off",
      "REQUEST_METHOD"=>"GET",
      "SCRIPT_NAME"=>"",
      "warden" => warden
    })
    ActionCable.server.broadcast(
      'games_channel',
      game: render_game(game, renderer)
    )
  end

  private

  def render_game(game, renderer)
    renderer.render(
      partial: 'games/game',
      locals: { game: game, new: true }
    )
  end
end
