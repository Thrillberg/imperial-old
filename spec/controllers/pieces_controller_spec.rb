require 'rails_helper'

describe PiecesController do
  before do
    Game.create(pre_game: PreGame.create)
  end

  describe '#move' do
    let(:country) { Country.find_by_name('Germany') }

    context 'between adjacent regions' do
      let(:origin_region) { Region.find_by_name('Danzig') }
      let(:destination_region) { Region.find_by_name('Berlin') }
      let(:piece) { Army.create(country: country, region: origin_region) }

      it 'changes region' do
        put :move, params: { id: piece.id, destination: destination_region, origin: origin_region }

        piece.reload

        expect(piece.region).to eql(destination_region)
      end
    end

    context 'between non-adjacent regions' do
      let(:origin_region) { Region.find_by_name('Danzig') }
      let(:destination_region) { Region.find_by_name('Spain') }
      let(:piece) { Army.create(country: country, region: origin_region) }

      it 'does not update piece' do
        put :move, params: { id: piece.id, destination: destination_region, origin: origin_region }

        piece.reload

        expect(piece.region).to eql(origin_region)
      end
    end
  end
end
