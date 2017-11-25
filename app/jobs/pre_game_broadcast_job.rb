class PreGameBroadcastJob < ApplicationJob
  queue_as :default

  def perform(pre_game, warden)
    renderer = ApplicationController.renderer.new
    renderer.instance_variable_set(:@env, {
      "HTTP_HOST"=>"localhost:3000",
      "HTTPS"=>"off",
      "REQUEST_METHOD"=>"GET",
      "SCRIPT_NAME"=>"",
      "warden" => warden
    })
    ActionCable.server.broadcast(
      'pre_games_channel',
      game: render_pre_game(pre_game, renderer)
    )
  end

  private

  def render_pre_game(pre_game, renderer)
    renderer.render(
      partial: 'pre_games/pre_game',
      locals: { game: pre_game, new: true }
    )
  end
end
