require "rails_helper"

describe Game do
  it { should have_one :board }
  it { should have_many :players }
  it { should have_many :countries }

  before(:each) do
    @game = create(:game)
  end

  describe '#add_board' do
    it 'creates a board' do
      expect(Board.count).to eq(1)
    end
  end

  describe '#set_board_spaces' do
    it 'creates six countries' do
      expect(Country.count).to eq(6)
    end
  end

  describe '#assign_players_to_countries' do
    context '6 players' do
      it 'assigns each player to one country' do
        user = create(:user, email: "test@test.com", username: 'test', password: 'password')
        create_list(:player, 6, game: @game, user: user)
        @game.assign_players_to_countries
        Country.all.each do |country|
          expect(country.player).to be_kind_of(Player)
        end
      end
    end

    context '4 players' do
      it 'assigns 2 players to one country each, and 2 players to 2 countries' do
        user = create(:user, email: "test@test.com", username: 'test', password: 'password')
        create_list(:player, 4, game: @game, user: user)
        @game.assign_players_to_countries
        Country.all.each do |country|
          expect(country.player).to be_kind_of(Player)
        end
      end
    end
  end

  describe '#assign_users_to_players' do
    context '6 users' do
      it 'assigns each user to one player' do
        (1..6).each do |number|
          @game.users << create(:user, email: "#{number}@test.com", username: "#{number}-test", password: 'password')
        end
        @game.save
        @game.assign_users_to_players
        Player.all.each do |player|
          expect(player.user).to be_kind_of(User)
        end
        expect(Player.count).to eql(6)
      end
    end

    context '4 users' do
      it 'assigns each user to one player' do
        (1..4).each do |number|
          @game.users << create(:user, email: "#{number}@test.com", username: "#{number}-test", password: 'password')
        end
        @game.save
        @game.assign_users_to_players
        Player.all.each do |player|
          expect(player.user).to be_kind_of(User)
        end
        expect(Player.count).to eql(4)
      end
    end
  end

  # describe "#reconcile_users_and_players" do
  #   context 'first user' do
  #     let(:user) { create(:user) }
  #     let(:game) { create(:game_with_users, users_count: 1) }

  #     fit 'creates a player' do
  #       byebug
  #       expect(game.players.count).to eql(1)
  #     end
  #   end

  #   context 'add a user' do

  #   end

  #   context 'remove a user' do

  #   end
  # end

  describe "#set_up_money" do
    context '2 players' do
      let(:game) { create(:game_with_users, users_count: 2) }

      it 'gives each player 35 money' do
        game.set_up_money
        game.players.each do |player|
          expect(player.money).to eql(35)
        end
      end
    end

    context '3 players' do
      let(:game) { create(:game_with_users, users_count: 3) }

      it 'gives each player 24 money' do
        game.set_up_money
        game.players.each do |player|
          expect(player.money).to eql(24)
        end
      end
    end

    context '4-6 players' do
      (4..6).each do |count|
        let(:game) { create(:game_with_users, users_count: count) }

        it 'gives each player 13 money' do
          game.set_up_money
          game.players.each do |player|
            expect(player.money).to eql(13)
          end
        end
      end
    end
  end
end
