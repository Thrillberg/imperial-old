FactoryBot.define do
  factory :game do
    transient do
      users_count 2
    end

    after(:build) do |game, evaluator|
      users = create_list(:user, evaluator.users_count)
      users.each do |user|
        user.convert_to_investor(game)
      end
      game.update(current_country: game.countries.find_by(name: "austria_hungary"))
      game.start
    end
  end
end
