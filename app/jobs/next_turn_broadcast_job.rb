class NextTurnBroadcastJob < ApplicationJob
  def perform(game_id)
    ActionCable.server.broadcast(
      "next_turn_channel",
      game_id
    )
  end
end
