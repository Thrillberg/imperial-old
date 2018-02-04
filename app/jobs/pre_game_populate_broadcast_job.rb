class PreGamePopulateBroadcastJob < ApplicationJob
  queue_as :default

  def perform(user, game_id, action)
    renderer = ApplicationController.renderer.new
    ActionCable.server.broadcast(
      'pre_games_channel',
      {
        user: render_user(user, renderer),
        action: action,
        pre_game_id: game_id
      }
    )
  end

  private

  def render_user(user, renderer)
    renderer.render(
      partial: 'pre_games/user',
      locals: { user: user }
    )
  end
end
