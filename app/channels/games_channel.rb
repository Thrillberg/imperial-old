class GamesChannel < ApplicationCable::Channel  
  def subscribed
    stream_from 'games_channel'
  end

  def new_game(game)
    Game.create!
  end
end
