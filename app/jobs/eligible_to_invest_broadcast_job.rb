class EligibleToInvestBroadcastJob < ApplicationJob
  def perform(game_id, investor_id, investor_user_id)
    ActionCable.server.broadcast(
      "investors_channel",
      {
        game_id: game_id,
        investor_id: investor_id,
        investor_user_id: investor_user_id
      }
    )
  end
end
