puts "Creating six countries..."

["England", "France", "Germany", "Austria-Hungary", "Italy", "Russia"].each do |country_name|
  Country.create(name: country_name)
end

england = Country.find_by_name("England")
france = Country.find_by_name("France")
germany = Country.find_by_name("Germany")
russia = Country.find_by_name("Russia")
austria_hungary = Country.find_by_name("Austria-Hungary")
italy = Country.find_by_name("Italy")

puts "Creating English regions..."

["Dublin", "Edinburgh", "Liverpool", "Sheffield", "London"].each do |region_name|
  england.regions << Region.create(name: region_name)
end

puts "Creating French regions..."

["Brest", "Paris", "Dijon", "Bordeaux", "Marseille"].each do |region_name|
  france.regions << Region.create(name: region_name)
end

puts "Creating German regions..."

["Hamburg", "Berlin", "Danzig", "Cologne", "Munich"].each do |region_name|
  germany.regions << Region.create(name: region_name)
end

puts "Creating Russian regions..."

["St. Petersburg", "Moscow", "Warsaw", "Kiev", "Odessa"].each do |region_name|
  russia.regions << Region.create(name: region_name)
end

puts "Creating Austro-Hungarian regions..."

["Prague", "Lemberg", "Vienna", "Budapest", "Trieste"].each do |region_name|
  austria_hungary.regions << Region.create(name: region_name)
end

puts "Creating Italian regions..."

["Genoa", "Venice", "Florence", "Rome", "Naples"].each do |region_name|
  italy.regions << Region.create(name: region_name)
end
