class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :games
  has_many :investors
  has_many :pre_games, through: :pre_game_users

  def online?
    $redis.get("user_#{self.id}_online").nil?
  end
end
