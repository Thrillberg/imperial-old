class InvestorCard < ApplicationRecord
  belongs_to :game
  belongs_to :investor

  def pass_card
    update(investor: investor.next)
  end
end
