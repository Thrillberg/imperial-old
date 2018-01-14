require "rails_helper"

describe Game do
  it { should have_many :countries }
  it { should have_many :regions }
  it { should have_many :investors }
  it { should have_one :current_country }

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
end
