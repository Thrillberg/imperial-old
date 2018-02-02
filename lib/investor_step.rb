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
    investor_card_holder = investor_card.investor
    money = investor_card_holder.money + 2
    investor_card_holder.update(money: money)
  end

  def purchase_bond(bond_id, investor)
    bond = bonds.find(bond_id)
    bond.update(investor: investor)
    money = investor.money - bond.price
    investor.update(money: money)
  end
end
