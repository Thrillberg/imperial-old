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
        user = create(:user, email: "test@test.com", password: 'password')
        create_list(:player, 6, game: @game, user: user)
        @game.assign_players_to_countries
        Country.all.each do |country|
          expect(country.player).to be_kind_of(Player)
        end
      end
    end

    context '4 players' do
      it 'assigns 2 players to one country each, and 2 players to 2 countries' do
        user = create(:user, email: "test@test.com", password: 'password')
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
          @game.users << create(:user, email: "#{number}@test.com", password: 'password')
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
          @game.users << create(:user, email: "#{number}@test.com", password: 'password')
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
end
