class PreGamePopulateBroadcastJob < ApplicationJob
  queue_as :default

  def perform(user)
    renderer = ApplicationController.renderer.new
    ActionCable.server.broadcast(
      'pre_games_channel',
      user: render_user(user, renderer)
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
