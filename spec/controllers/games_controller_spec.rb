require 'rails_helper'

describe GamesController do
  let(:user) { create(:user) }
  let(:country) { create(:country, name: 'country', money: 9) }
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

    it 'deducts 1 from the country’s money' do
      post :import, params: { id: game.id, region: region.name }
      country.reload
      expect(country.money).to eq(8)
    end
  end
end
