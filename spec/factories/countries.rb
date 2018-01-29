FactoryBot.define do
  factory :country do
    transient do
      bonds_count 9
    end

    after(:build) do |country, evaluator|
      create_list(:bond, evaluator.bonds_count, country: country, game: country.game)
    end
  end
end
