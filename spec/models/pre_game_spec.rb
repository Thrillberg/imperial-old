require "rails_helper"

describe PreGame do
  it { should have_many :users }
  it { should have_many :pre_game_users }
end
