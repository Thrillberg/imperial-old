FactoryBot.define do
  factory :game do
    transient do
      users_count 2
    end

    after(:create) do |game, evaluator|
      users = create_list(:user, evaluator.users_count)
      users.each do |user|
        user.investors.create(game: game)
      end
      game.start
    end
  end
end
