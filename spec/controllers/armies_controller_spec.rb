require 'rails_helper'

describe ArmiesController do
  describe '#move' do
    let(:country) { Country.create(name: 'Germany') }
    let(:origin_region) { Region.create(name: 'Saarbruecken') }
    let(:destination_region) { Region.create(name: 'Berlin') }
    let(:army) { Army.create(country: country, region: origin_region) }

    it 'changes region' do
      put :move, params: { id: army.id, destination: destination_region }

      army.reload
      
      expect(army.region).to eql(destination_region)
    end
  end
end
