FactoryBot.define do
  factory :game do

    factory :game_with_users do
      transient do
        users_count 2
      end

      after(:create) do |game, evaluator|
        create_list(:user, evaluator.users_count, games: [game])
      end
    end
  end
end
