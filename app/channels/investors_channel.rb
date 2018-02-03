class InvestorsChannel < ApplicationCable::Channel  
  def subscribed
    stream_from "investors_channel"
  end
end
