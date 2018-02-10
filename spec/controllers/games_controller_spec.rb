require "rails_helper"

describe GamesController do
  let(:pre_game) { create(:pre_game) }
  let(:game) { pre_game.game }

  before(:each) do
    sign_in pre_game.creator
  end

  describe "POST #create" do
    let(:params) do
      {
        pre_game_id: pre_game.id
      }
    end
    let(:subject) { post :create, params: params }

    it "creates a new Game" do
      expect{ subject }.to change{ Game.count }.by(1)
    end

    describe "establishing correct models" do
      before(:each) do
        subject
        pre_game.reload
      end

      it "creates an investor for each user" do
        expect(game.investors.count).to eq(pre_game.users.count)
      end

      it "gives investors the right amount of money" do
        game.investors.each do |investor|
          expect(investor.money).to eq(6)
        end
      end

      it "gives the InvestorCard to a player who does not control Austria-Hungary" do
        austria_hungary = game.countries.find_by(name: "austria_hungary")
        austria_hungary_investor = game.investors.select(game.countries.include? austria_hungary)
        expect(game.investor_card.investor).not_to eq(austria_hungary_investor)
      end

      it "sets Austria Hungary as current_country" do
        expect(game.current_country).to eq(game.countries.find_by(name: "austria_hungary"))
      end

      it "distributes initial bonds" do
        game.investors.each do |investor|
          expect(investor.bonds.count).to eq(2)
        end
      end
    end

    it "redirects to game" do
      subject
      pre_game.reload
      expect(response).to redirect_to game_path(game)
    end
  end

  describe "GET #show" do
    let(:params) do
      {
        id: game.id
      }
    end
    let(:subject) { get :show, params: params }

    it "redirects to the game_investor_path" do
      post :create, params: { pre_game_id: pre_game.id }
      pre_game.reload
      subject
      expect(response).to redirect_to game_investor_path(assigns(:game), assigns(:current_investor))
    end
  end
end
