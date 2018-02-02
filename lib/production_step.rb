module ProductionStep
  def production
    current_country.regions.select(&:has_factory).each do |region|
      if region.factory_type == :armaments
        Army.create(region: region, country: region.country)
      else
        Fleet.create(region: region, country: region.country)
      end
    end
  end
end
