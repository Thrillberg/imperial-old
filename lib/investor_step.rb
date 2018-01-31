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

  def purchase_bond(bond_id)
    bond = bonds.find(bond_id)
    bond.update(investor: current_investor)
    money = current_investor.money - bond.price
    current_investor.update(money: money)
  end

  def pass_investor_card
    current_investor.next.update(has_investor_card: true)
    current_investor.update(has_investor_card: false)
  end
end
