FactoryBot.define do
  factory :pre_game do
    game

    factory :pre_game_with_users do
      transient do
        users_count 2
      end

      after(:create) do |pre_game, evaluator|
        create_list(:user, evaluator.users_count, pre_games: [pre_game])
      end
    end
  end
end
