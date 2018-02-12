require "rails_helper"

describe InvestorsController do
  let(:game) { double("game") }
  let(:game_id) { "123" }
  let(:user) { create(:user) }
  let(:investor_id) { "456" }
  let(:region_name) { "Ubekibekistanstan" }

  before(:each) do
    sign_in user
    allow(Game).to receive(:find).with(game_id).and_return game
  end

  describe "POST #build_factory" do
    let(:params) do
      {
        region: region_name,
        game_id: game_id,
        id: investor_id
      }
    end
    let(:subject) { post :build_factory, params: params }

    it "calls game#build_factory" do
      expect(game).to receive(:build_factory).with(params[:region])
      subject
      expect(response).to redirect_to game_investor_path
    end
  end

  describe "POST #import" do
    let(:params) do
      {
        region: region_name,
        game_id: game_id,
        id: investor_id 
      }
    end
    let(:subject) { post :import, params: params }

    context "import count is less than 3" do
      before(:each) do
        params[:import_count] = "1"
      end

      it "calls game#import" do
        expect(game).to receive(:import).with(region_name)
        subject
      end
    end

    context "import count is 3" do
      before(:each) do
        params[:import_count] = "3"
      end

      it "calls game#next_turn" do
        expect(game).to receive(:next_turn)
        subject
        expect(response).to redirect_to game_investor_path
      end
    end
  end

  describe "GET #maneuver" do
    let(:params) do
      {
        game_id: game_id,
        id: investor_id 
      }
    end
    let(:subject) { get :maneuver, params: params }
    let(:expected_regions) { ["blort", "blard"] }
    let(:investor) { double("investor") }

    before(:each) do
      allow(game).to receive(:investor).with(user).and_return investor
      allow(game).to receive(:regions_with_factories).and_return []
      allow(game).to receive(:regions_with_pieces).and_return []
      allow(game).to receive(:regions_with_flags).and_return []
    end


    context "no origin region" do
      it "sets eligible regions" do
        allow_any_instance_of(InvestorsHelper).to receive(:eligible_regions).with("maneuver").and_return(expected_regions)
        subject
        expect(assigns(:eligible_regions)).to eq(expected_regions)
      end
    end

    context "with an origin region" do
      before(:each) do
        params[:origin_region] = region_name
      end

      it "redirects to maneuver destination route" do
        allow_any_instance_of(InvestorsHelper).to receive(:eligible_regions).with("maneuver").and_return(expected_regions)
        expect(subject).to redirect_to "/games/#{params[:game_id]}/investors/#{params[:id]}/maneuver_destination?origin_region=#{params[:origin_region]}"
      end
    end
  end
end
