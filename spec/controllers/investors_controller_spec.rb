require "rails_helper"

describe InvestorsController do
  let(:game) { create(:game) }
  let(:user) { game.investors.first.user }
  let(:investor) { game.investors.first }

  before(:each) do
    sign_in user
  end

  describe "POST #build_factory" do
    let(:params) do
      {
        region: game.regions.sample.name,
        game_id: game.id,
        id: investor.id 
      }
    end
    let(:subject) { post :build_factory, params: params }

    it "calls InvestorsHelper.eligible_regions" do
      expect_any_instance_of(InvestorsHelper).to receive(:eligible_regions).with(game.current_country.step)
      subject
    end

    it "calls game#build_factory" do
      expect_any_instance_of(Game).to receive(:build_factory).with(params[:region])
      subject
    end

    it "redirects to game_investor_path" do
      subject
      expect(response).to redirect_to game_investor_path
    end
  end
end
