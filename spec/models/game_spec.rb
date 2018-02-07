require "rails_helper"

describe Game do
  it { should have_many :countries }
  it { should have_many :regions }
  it { should have_many :investors }
  it { should belong_to :current_country }


  describe 'callbacks' do
    let(:game) { build(:game) }

    it 'triggers callbacks on save' do
      expect_any_instance_of(Game).to receive(:set_up_countries)
      expect_any_instance_of(Game).to receive(:set_up_neutral_regions)
      expect_any_instance_of(Game).to receive(:set_up_sea_regions)
      expect_any_instance_of(Game).to receive(:set_up_factories)
      game.save
    end
  end

  describe 'start' do
    let(:game) { build(:game) }

    it 'sets up money' do
      game.set_up_money
      game.investors.each do |investor|
        expect(investor.money).to eq(35)
      end
    end

    it 'distributes initial bonds' do
      game.set_up_money
      game.distribute_initial_bonds
      game.investors.each do |investor|
        expect(investor.money).to eq(8)
      end
    end
  end

  describe 'regions_with_pieces' do
    let(:game) { build(:game) }
    let(:army) { build(:army) }
    let(:region_name) { "vienna" }
    let(:country_name) { "austria_hungary" }
    let(:expected_pieces) do
      [{
        region_name: region_name,
        country_name: country_name,
        type: "army",
        color: "#CCCC00",
        font_color: "black"
      }]
    end
    
    it 'returns regions with pieces' do
      game.start
      region = Region.find_by(name: region_name)
      country = Country.find_by(name: country_name)
      army.update(region: region, country: country)
      expect(game.regions_with_pieces).to eq(expected_pieces)
    end
  end
end
