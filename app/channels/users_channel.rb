class UsersChannel < ApplicationCable::Channel  
  def subscribed
    $redis.set("user_#{current_user.id}_online", "1")
    stream_from("users_channel")
    ActionCable.server.broadcast "users_channel",
                                 user_id: current_user.id,
                                 online: true
  end

  def unsubscribed
    $redis.del("user_#{current_user.id}_online")
    ActionCable.server.broadcast "users_channel",
                                 user_id: current_user.id,
                                 online: false
  end
end
