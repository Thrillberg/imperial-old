require "rails_helper"

describe Game do
  it { should have_many :countries }
  it { should have_many :regions }
  it { should have_many :investors }
  it { should belong_to :current_country }


  describe 'callbacks' do
    let(:game) { build(:game) }

    it 'triggers callbacks on save' do
      expect(game).to receive(:set_up_countries_and_regions)
      expect(game).to receive(:set_up_neutral_regions)
      expect(game).to receive(:set_up_sea_regions)
      expect(game).to receive(:set_up_factories)
      game.save
    end
  end

  describe 'start' do
    let(:game_with_investors) { build(:game_with_investors) }

    it 'sets up money' do
      game_with_investors.set_up_money
      game_with_investors.investors.each do |investor|
        expect(investor.money).to eq(35)
      end
    end

    it 'creates bonds' do
      game_with_investors.create_bonds
      expect(Bond.count).to eq(54)
    end

    it 'distributed initial bonds' do
      game_with_investors.set_up_money
      game_with_investors.create_bonds
      game_with_investors.distribute_initial_bonds
      game_with_investors.investors.each do |investor|
        expect(investor.money).to eq(8)
      end
    end
  end
end
