require "rails_helper"

describe InvestorsController do
  let(:game) { create(:game) }
  let(:user) { game.investors.first.user }
  let(:investor) { game.investors.first }
  let(:country_regions) { game.countries.map(&:regions).flatten }

  before(:each) do
    sign_in user
  end

  describe "POST #build_factory" do
    let(:params) do
      {
        region: country_regions.sample.name,
        game_id: game.id,
        id: investor.id 
      }
    end
    let(:subject) { post :build_factory, params: params }

    it "calls game#build_factory" do
      expect_any_instance_of(Game).to receive(:build_factory).with(params[:region])
      subject
    end

    it "redirects to game_investor_path" do
      subject
      expect(response).to redirect_to game_investor_path
    end
  end

  describe "POST #import" do
    let(:region) { country_regions.sample }
    let(:params) do
      {
        region: region.name,
        game_id: game.id,
        id: investor.id 
      }
    end
    let(:subject) { post :import, params: params }

    context "import count is less than 3" do
      before(:each) do
        params[:import_count] = "1"
      end

      it "adds a piece to the region" do
        expect{ subject }.to change{ region.pieces.count }.by(1)
      end
    end

    context "import count is 3" do
      before(:each) do
        params[:import_count] = "3"
      end

      it "does not add a piece to the region" do
        expect{ subject }.to_not change{ region.pieces.count }
      end

      it "redirects to game_investor_path" do
        subject
        expect(response).to redirect_to game_investor_path
      end
    end
  end
end
