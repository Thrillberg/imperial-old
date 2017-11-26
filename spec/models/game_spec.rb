require 'rails_helper'

describe Game do
  it { should have_one :pre_game }
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

  xdescribe '#assign_governments_to_countries' do
    context '6 governments' do
      it 'assigns each government to one country' do
        create_list(:government, 6)
        @game.assign_governments_to_countries
        Country.all.each do |country|
          expect(country.government).to be_kind_of(Government)
        end
      end
    end

    context '4 governments' do
      it 'assigns 2 governments to one country each, and 2 governments to 2 countries' do
        user = create(:user, email: "test@test.com", username: 'test', password: 'password')
        create_list(:government, 4, game: @game, user: user)
        @game.assign_governments_to_countries
        Country.all.each do |country|
          expect(country.government).to be_kind_of(Government)
        end
      end
    end
  end

  xdescribe '#assign_users_to_governments' do
    context '6 users' do
      it 'assigns each user to one government' do
        (1..6).each do |number|
          @game.users << create(:user, email: "#{number}@test.com", username: "#{number}-test", password: 'password')
        end
        @game.save
        @game.assign_users_to_governments
        Government.all.each do |government|
          expect(government.user).to be_kind_of(User)
        end
        expect(Government.count).to eql(6)
      end
    end

    context '4 users' do
      it 'assigns each user to one government' do
        (1..4).each do |number|
          @game.users << create(:user, email: "#{number}@test.com", username: "#{number}-test", password: 'password')
        end
        @game.save
        @game.assign_users_to_governments
        Government.all.each do |government|
          expect(government.user).to be_kind_of(User)
        end
        expect(Government.count).to eql(4)
      end
    end
  end

  describe "#set_up_money" do
    context '2 governments' do
      let(:game) { create(:game_with_users, users_count: 2) }

      it 'gives each government 35 money' do
        game.set_up_money
        game.governments.each do |government|
          expect(government.money).to eql(35)
        end
      end
    end

    context '3 governments' do
      let(:game) { create(:game_with_users, users_count: 3) }

      it 'gives each government 24 money' do
        game.set_up_money
        game.governments.each do |government|
          expect(government.money).to eql(24)
        end
      end
    end

    context '4-6 governments' do
      (4..6).each do |count|
        let(:game) { create(:game_with_users, users_count: count) }

        it 'gives each government 13 money' do
          game.set_up_money
          game.governments.each do |government|
            expect(government.money).to eql(13)
          end
        end
      end
    end
  end
end
