namespace :set_game_state do
  desc "setting up a mid-play game"
  task mid_game: :environment do
    user1 = User.create!(:email => "test1@test.com", :password => 'password', :password_confirmation => 'password', username: "user1")
    user2 = User.create!(:email => "test2@test.com", :password => 'password', :password_confirmation => 'password', username: "user2")
    pregame = PreGame.create!(users: [user1, user2], creator: user1)
    game = pregame.build_game
    pregame.users.map { |user| user.investors.create(game: game) }
    game.start
    england = game.countries.find_by(name: "england")
    france = game.countries.find_by(name: "france")
    austria_hungary = game.countries.find_by(name: "austria_hungary")
    germany = game.countries.find_by(name: "germany")
    russia = game.countries.find_by(name: "russia")
    italy = game.countries.find_by(name: "italy")

    Army.create!(country: france, region: Region.find_by(name: "belgium"))
    Army.create!(country: france, region: Region.find_by(name: "spain"))
    Army.create!(country: france, region: Region.find_by(name: "portugal"))
    Army.create!(country: germany, region: Region.find_by(name: "holland"))
    Army.create!(country: germany, region: Region.find_by(name: "denmark"))
    Army.create!(country: germany, region: Region.find_by(name: "norway"))
    Army.create!(country: russia, region: Region.find_by(name: "sweden"))
    Army.create!(country: russia, region: Region.find_by(name: "romania"))
    Army.create!(country: austria_hungary, region: Region.find_by(name: "bulgaria"))
    Army.create!(country: austria_hungary, region: Region.find_by(name: "west_balkan"))
    Army.create!(country: austria_hungary, region: Region.find_by(name: "turkey"))

    Flag.create!(country: france, region: Region.find_by(name: "belgium"))
    Flag.create!(country: france, region: Region.find_by(name: "spain"))
    Flag.create!(country: france, region: Region.find_by(name: "portugal"))
    Flag.create!(country: germany, region: Region.find_by(name: "holland"))
    Flag.create!(country: germany, region: Region.find_by(name: "denmark"))
    Flag.create!(country: germany, region: Region.find_by(name: "norway"))
    Flag.create!(country: russia, region: Region.find_by(name: "sweden"))
    Flag.create!(country: russia, region: Region.find_by(name: "romania"))
    Flag.create!(country: austria_hungary, region: Region.find_by(name: "bulgaria"))
    Flag.create!(country: austria_hungary, region: Region.find_by(name: "west_balkan"))
    Flag.create!(country: austria_hungary, region: Region.find_by(name: "turkey"))
  end
end
