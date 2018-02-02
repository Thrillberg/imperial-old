class GamesController < ApplicationController
  before_action :authenticate_user!

  def create
    pre_game = PreGame.find params[:pre_game_id]
    game = Game.new(pre_game_id: pre_game.id)
    if game.save
      austria_hungary = game.countries.find_by(name: "austria_hungary")
      investors = pre_game.users.map { |user| user.convert_users_to_investors(game) }
      game.establish_investor_order
      eligible_investors = investors.reject { |investor| investor.countries.include? austria_hungary }
      eligible_investors.sample.update(has_investor_card: true)
      game.update(investors: investors, current_country: austria_hungary)
      game.start
      redirect_to game
    end
  end

  def show
    @game = Game.find(params[:id])
    @current_investor = @game.investors.find_by(user: current_user)
    redirect_to game_investor_path(game_id: @game.id, id: @current_investor.id)
  end
end
