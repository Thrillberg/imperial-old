class PurchasedBondBroadcastJob < ApplicationJob
  def perform(game_id, investor_id, bond_id)
    ActionCable.server.broadcast(
      "investors_channel",
      {
        game_id: game_id,
        investor_id: investor_id,
        bond_id: bond_id
      }
    )
  end
end
