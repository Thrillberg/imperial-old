module InvestorStep
  def pay_interest
    current_country.bonds.each do |bond|
      if bond.investor
        money = bond.investor.money
        bond.investor.update(money: money + bond.interest)
      end
    end 
  end

  def activate_investor
    investor_card_holder = Investor.where(has_investor_card: true).take
    money = investor_card_holder.money + 2
    investor_card_holder.update(money: money)
  end
end
