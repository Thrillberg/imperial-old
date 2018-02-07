require "rails_helper"

describe Country do
  it { should have_many :pieces }
  it { should have_many :regions }
  it { should have_many :bonds }
  it { should belong_to :game }

  it { should have_db_column(:name) }
  it { should have_db_column(:money) }
  it { should have_db_column(:step) }

  describe '#owner' do
    let(:game) { create(:game) }
    let(:country) { create(:country, game: game, name: Settings.countries.keys.sample) }
    let(:other_investor) { create(:investor, game: game, user: create(:user)) }
    let(:expected_investor) { create(:investor, game: game, user: create(:user)) }

    it 'returns the owner of the most bond value for the country' do
      country.bonds.where(price: 30).update(investor: expected_investor)
      country.bonds.where(price: 2).update(investor: other_investor)
      owner = country.owner
      expect(owner).to eql(expected_investor)
    end
  end
end
