class PreGame < ApplicationRecord
  has_many :pre_game_users
  has_many :users, through: :pre_game_users
  belongs_to :creator, :class_name => "User", :foreign_key => "user_id"
  belongs_to :game, optional: true

  def get_users
    users_string = ''
    users.each do |user|
      users_string << user.username + ', '
    end
    users_string.chomp(', ') if users_string != ''
  end

  def started?
    game ? true : false
  end
end
