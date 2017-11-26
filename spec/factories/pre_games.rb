FactoryBot.define do
  factory :pre_game do
    game
    creator { create(:user) }
  end
end
