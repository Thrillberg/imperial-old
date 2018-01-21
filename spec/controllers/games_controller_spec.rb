require 'rails_helper'

describe GamesController do
  let(:user) { create(:user) }
  let(:country) { create(:country, name: 'country') }
  let(:game) { create(:game, current_country: country) }
  let(:region) { create(:region, name: 'region', country: country, game: game) }

  before(:each) do
    sign_in user
  end

  describe '#import' do
    it 'builds a new army at the given region' do
      expect {
        post :import, params: { id: game.id, region: region.name }
      }.to change{Piece.count}.by(1)
    end

    it 'deducts 3 from the investor’s money' do
      region.country.owner.update(money: 3)

      post :import, params: { id: game.id, region: region.name }

      expect(region.country.owner.money).to eq(0)
    end
  end
end
