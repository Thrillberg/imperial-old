FactoryBot.define do
  factory :pre_game do
    creator { create(:user) }

    after(:create) do |pre_game|
      2.times do
        create(:pre_game_user, pre_game: pre_game, user: create(:user))
      end
      create(:pre_game_user, pre_game: pre_game, user: pre_game.creator)
    end
  end
end
