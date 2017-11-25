class PreGamesChannel < ApplicationCable::Channel  
  def subscribed
    stream_from 'pre_games_channel'
  end
end
