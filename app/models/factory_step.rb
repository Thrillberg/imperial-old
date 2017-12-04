class FactoryStep < TurnStep
  def name
    "Factory"
  end

  def self.execute(country)
    country.money -= 5
  end
end
