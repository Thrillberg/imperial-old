require "rails_helper"

describe InvestorsHelper do
  describe "#eligible_regions" do
    let(:game) { double("game") }
    let(:current_country) { double("country") }

    before(:each) do
      allow(game).to receive(:current_country).and_return(current_country)
    end

    context "action is maneuver" do
      let(:action) { :maneuver_1 }

      context "there are pieces" do
        let(:piece1) { double("piece") }
        let(:piece2) { double("piece") }
        let(:pieces) { [piece1, piece2] }

        before(:each) do
          allow(piece1).to receive(:region).and_return(build_stubbed(:region, name: 'hooey'))
          allow(piece2).to receive(:region).and_return(build_stubbed(:region, name: 'kablooey'))
          allow(piece1).to receive(:id).and_return(1)
          allow(piece2).to receive(:id).and_return(2)
          allow(current_country).to receive(:pieces).and_return pieces
        end

        it "when none have moved, returns an array of names of regions that have pieces" do
          session[:moved_pieces_ids] = []
          assign(:game, game)
          expect(helper.eligible_regions(:maneuver)).to eql ['hooey', 'kablooey']
        end

        it "when all have moved, returns an empty array" do
          session[:moved_pieces_ids] = [1, 2]
          assign(:game, game)
          expect(helper.eligible_regions(:maneuver)).to eql []
        end
      end

      context "there are no pieces"do
        before(:each) do
          allow(current_country).to receive(:pieces).and_return []
        end

        it "returns an empty array" do
          assign(:game, game)
          expect(helper.eligible_regions(:maneuver)).to eql []
        end
      end
    end

    context "action is maneuver_destination" do
      let(:action) { :maneuver_destination }
      let(:region_names) { ["destination-region", "sunshine-region"] }

      it "returns neighbors from Settings file" do
        expect(Settings).to receive(:neighbors).and_return({blort: region_names})
        expect(helper.eligible_regions(:maneuver_destination, { origin_region: :blort })).to eql region_names
      end
    end

    context "action is factory" do
      let(:action) { :factory }
      let(:region1) { build_stubbed("region") }
      let(:region2) { build_stubbed("region") }
      let(:regions) { [region1, region2] }
      let(:region_names) { regions.map(&:name) }

      before(:each) do
        allow(current_country).to receive(:regions).and_return regions
      end

      it "returns an array of region names" do
        assign(:game, game)
        expect(helper.eligible_regions(:factory)).to eql region_names
      end
    end

    context "action is import" do
      let(:action) { :import }
      let(:region1) { build_stubbed("region") }
      let(:region2) { build_stubbed("region") }
      let(:regions) { [region1, region2] }
      let(:region_names) { regions.map(&:name) }

      before(:each) do
        allow(current_country).to receive(:regions).and_return regions
      end

      it "returns an array of region names" do
        assign(:game, game)
        expect(helper.eligible_regions(:import)).to eql region_names 
      end
    end
  end
end
