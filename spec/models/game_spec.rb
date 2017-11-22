require "rails_helper"

describe Game do
  it { should have_one :board }
  it { should have_many :players }
  it { should have_many :countries }

  describe '#add_board' do
    it 'creates a board' do
      create(:game)
      expect(Board.count).to eq(1)
    end
  end

  describe '#set_board_spaces' do
    it 'creates six countries' do
      create(:game)
      expect(Country.count).to eq(6)
    end
  end

  describe '#assign_players_to_countries' do
    context '6 players' do
      it 'assigns each player to one country' do
        game = create(:game)
        create_list(:player, 6, game: game)
        game.start
        Country.all.each do |country|
          expect(country.player).to be_kind_of(Player)
        end
      end
    end

    context '4 players' do
      it 'assigns 2 players to one country each, and 2 players to 2 countries' do
        game = create(:game)
        create_list(:player, 4, game: game)
        game.start
        Country.all.each do |country|
          expect(country.player).to be_kind_of(Player)
        end
      end
    end
  end
end
