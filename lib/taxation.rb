module Taxation
  def get_taxes
    taxes = 0
    taxes += current_country.regions.select(&:has_factory).count * 2
    taxes += current_country.flags.count
    taxes
  end

  def move_on_tax_chart(taxes)
    tax_chart = Settings.tax_chart
    previous_position = tax_chart.index(current_country.position_on_tax_chart)
    if taxes <= 5
      current_country.update(position_on_tax_chart: tax_chart[0])
    elsif taxes >= 15
      current_country.update(position_on_tax_chart: tax_chart[10])
      if previous_position < 10
        income = taxes - previous_position - current_country.pieces.count
        money = current_country.money
        money += income if income > 0
        current_country.update(money: money)
      end
    else
      current_country.update(position_on_tax_chart: taxes.to_s)
      if previous_position < taxes
        income = taxes - previous_position - current_country.pieces.count
        money = current_country.money
        money += income if income > 0
        current_country.update(money: money)
      end
    end
    current_country.position_on_tax_chart
  end

  def add_power_points
    points = Settings.tax_chart.index(current_country.position_on_tax_chart)
    score = current_country.score + points
    current_country.update(score: score)
  end
end
