require "rails_helper"

describe InvestorsHelper do
  describe "#eligible_regions" do
    let(:game) { create(:game) }
    let(:current_country) { game.current_country }

    context "action is maneuver" do
      let(:action) { :maneuver_1 }
      let(:region_names) { current_country.regions.map(&:name) }

      context "there are pieces" do
        before(:each) do
          session[:moved_pieces_ids] = []
          game.current_country.regions.each do |region|
            Piece.create!(region: region, country: current_country)
          end
          Region.create!(name: "bogus-region", game: game)
        end

        it "when none have moved, returns an array of names of regions that have pieces" do
          assign(:current_country, current_country)
          expect(helper.eligible_regions(:maneuver)).to eql region_names
        end

        it "when all have moved, returns an empty array" do
          region_names.each do |region_name|
            session[:moved_pieces_ids] << Piece.find_by(region: Region.find_by(name: region_name)).id
          end

          assign(:current_country, current_country)
          expect(helper.eligible_regions(:maneuver)).to eql []
        end
      end

      context "there are no pieces"do
        it "returns an empty array" do
          assign(:current_country, current_country)
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
      let(:region_names) { current_country.regions.map(&:name) }

      before(:each) do
        current_country.regions.each do |region|
          region.update(has_factory: false)
        end
        Region.create!(name: "bogus-region", game: game, has_factory: true, country: current_country)
      end

      it "returns an array of region names" do
        assign(:current_country, current_country)
        expect(helper.eligible_regions(:factory)).to eql region_names
      end
    end

    context "action is import" do
      let(:action) { :import }
      let(:expected_region_names) { current_country.regions.map(&:name) }

      before(:each) do
        Region.create!(name: "bogus-region", game: game, country: Country.create!(name: "italy", game: game))
      end

      it "returns an array of region names" do
        assign(:current_country, current_country)
        expect(helper.eligible_regions(:import)).to eql expected_region_names
      end
    end
  end
end
