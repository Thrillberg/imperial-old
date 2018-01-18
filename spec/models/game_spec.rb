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

    it 'distributes initial bonds' do
      game_with_investors.set_up_money
      game_with_investors.create_bonds
      game_with_investors.distribute_initial_bonds
      game_with_investors.investors.each do |investor|
        expect(investor.money).to eq(8)
      end
    end
  end

  describe 'get_rondel' do
    let(:game_with_investors) { build(:game_with_investors) }
    let(:steps) { [{first: "step"}, {second: "step"}] }

    it 'returns steps' do
      game_with_investors.start
      game_with_investors.update(current_country: Country.first)
      expect(TurnStep).to receive_message_chain(:new, :get_steps).and_return(steps)
      expect(game_with_investors.get_rondel).to eq(steps)
    end
  end

  describe 'regions_with_pieces' do
    let(:game_with_investors) { build(:game_with_investors) }
    let(:army) { build(:army) }
    let(:region_name) { "vienna" }
    let(:country_name) { "austria_hungary" }
    let(:expected_pieces) do
      [{
        region_name: region_name,
        country_name: country_name,
        type: "Army",
        color: "yellow"
      }]
    end
    
    it 'returns regions with pieces' do
      game_with_investors.start
      region = Region.find_by(name: region_name)
      country = Country.find_by(name: country_name)
      army.update(region: region, country: country)
      expect(game_with_investors.regions_with_pieces).to eq(expected_pieces)
    end
  end
end
