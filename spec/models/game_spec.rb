require 'rails_helper'

describe Game do
  it { should have_one :board }
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

  xdescribe '#assign_investors_to_countries' do
    context '6 investors' do
      it 'assigns each investor to one country' do
        create_list(:investor, 6)
        @game.assign_investors_to_countries
        Country.all.each do |country|
          expect(country.investor).to be_kind_of(Investor)
        end
      end
    end

    context '4 investors' do
      it 'assigns 2 investors to one country each, and 2 investors to 2 countries' do
        user = create(:user, email: "test@test.com", username: 'test', password: 'password')
        create_list(:investor, 4, game: @game, user: user)
        @game.assign_investors_to_countries
        Country.all.each do |country|
          expect(country.investor).to be_kind_of(Investor)
        end
      end
    end
  end

  xdescribe '#assign_users_to_investors' do
    context '6 users' do
      it 'assigns each user to one investor' do
        (1..6).each do |number|
          @game.users << create(:user, email: "#{number}@test.com", username: "#{number}-test", password: 'password')
        end
        @game.save
        @game.assign_users_to_investors
        Investor.all.each do |investor|
          expect(investor.user).to be_kind_of(User)
        end
        expect(Investor.count).to eql(6)
      end
    end

    context '4 users' do
      it 'assigns each user to one investor' do
        (1..4).each do |number|
          @game.users << create(:user, email: "#{number}@test.com", username: "#{number}-test", password: 'password')
        end
        @game.save
        @game.assign_users_to_investors
        Investor.all.each do |investor|
          expect(investor.user).to be_kind_of(User)
        end
        expect(Investor.count).to eql(4)
      end
    end
  end

  describe "#set_up_money" do
    context '2 investors' do
      let(:game) { create(:game_with_investors, investors_count: 2) }

      it 'gives each investor 35 money' do
        game.set_up_money
        game.investors.each do |investor|
          expect(investor.money).to eql(35)
        end
      end
    end

    context '3 investors' do
      let(:game) { create(:game_with_investors, investors_count: 3) }

      it 'gives each investor 24 money' do
        game.set_up_money
        game.investors.each do |investor|
          expect(investor.money).to eql(24)
        end
      end
    end

    context '4-6 investors' do
      (4..6).each do |count|
        let(:game) { create(:game_with_investors, investors_count: count) }

        it 'gives each investor 13 money' do
          game.set_up_money
          game.investors.each do |investor|
            expect(investor.money).to eql(13)
          end
        end
      end
    end
  end
end
