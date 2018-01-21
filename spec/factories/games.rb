FactoryBot.define do
  factory :game do
    factory :game_with_investors do
      transient do
        investors_count 2
      end

      after(:build) do |game, evaluator|
        create_list(:investor, evaluator.investors_count, game: game)
      end
    end
  end
end
