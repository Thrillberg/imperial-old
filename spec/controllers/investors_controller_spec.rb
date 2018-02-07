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

  describe "GET #maneuver" do
    let(:params) do
      {
        game_id: game.id,
        id: investor.id 
      }
    end
    let(:subject) { get :maneuver, params: params }
    let(:expected_regions) { ["blort", "blard"] }

    context "no origin region" do
      it "sets eligible regions" do
        game.current_country.update(step: "maneuver")
        allow_any_instance_of(InvestorsHelper).to receive(:eligible_regions).with("maneuver").and_return(expected_regions)
        subject
        expect(assigns(:eligible_regions)).to eq(expected_regions)
      end
    end

    context "with an origin region" do
      let(:origin_region) { game.current_country.regions.sample }
      before(:each) do
        params[:origin_region] = origin_region.name
      end

      it "redirects to maneuver destination route" do
        expect(subject).to redirect_to "/games/#{params[:game_id]}/investors/#{params[:id]}/maneuver_destination?origin_region=#{params[:origin_region]}"
      end
    end
  end
end
