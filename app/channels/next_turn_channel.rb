class NextTurnChannel < ApplicationCable::Channel  
  def subscribed
    stream_from "next_turn_channel"
  end
end
