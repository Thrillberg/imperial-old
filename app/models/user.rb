class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :games
  has_one :investor, through: :games
  has_many :pre_games, through: :pre_game_users

  def online?
    $redis.get("user_#{self.id}_online").nil?
  end

  def convert_to_investor(game)
    Investor.create(user: self, game: game, has_investor_card: false)
  end
end
