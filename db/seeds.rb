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

dublin = Region.create(name: "Dublin")
edinburgh = Region.create(name: "Edinburgh")
liverpool = Region.create(name: "Liverpool")
sheffield = Region.create(name: "Sheffield")
london = Region.create(name: "London")

[dublin, edinburgh, liverpool, sheffield, london].each do |region|
  england.regions << region
end

puts "Creating French regions..."

brest = Region.create(name: "Brest")
paris = Region.create(name: "Paris")
dijon = Region.create(name: "Dijon")
bordeaux = Region.create(name: "Bordeaux")
marseille = Region.create(name: "Marseille")

[brest, paris, dijon, bordeaux, marseille].each do |region|
  france.regions << region
end

puts "Creating German regions..."

hamburg = Region.create(name: "Hamburg")
berlin = Region.create(name: "Berlin")
danzig = Region.create(name: "Danzig")
cologne = Region.create(name: "Cologne")
munich = Region.create(name: "Munich")

[hamburg, berlin, danzig, cologne, munich].each do |region|
  germany.regions << region
end

puts "Creating Russian regions..."

st_petersburg = Region.create(name: "St. Petersburg")
moscow = Region.create(name: "Moscow")
warsaw = Region.create(name: "Warsaw")
kiev = Region.create(name: "Kiev")
odessa = Region.create(name: "Odessa")

[st_petersburg, moscow, warsaw, kiev, odessa].each do |region|
  russia.regions << region
end

puts "Creating Austro-Hungarian regions..."

prague = Region.create(name: "Prague")
lemberg = Region.create(name: "Lemberg")
vienna = Region.create(name: "Vienna")
budapest = Region.create(name: "Budapest")
trieste = Region.create(name: "Trieste")

[prague, lemberg, vienna, budapest, trieste].each do |region|
  austria_hungary.regions << region
end

puts "Creating Italian regions..."

genoa = Region.create(name: "Genoa")
venice = Region.create(name: "Venice")
florence = Region.create(name: "Florence")
rome = Region.create(name: "Rome")
naples = Region.create(name: "Naples")

[genoa, venice, florence, rome, naples].each do |region|
  italy.regions << region
end

puts "Creating neutral regions..."

spain = Region.create(name: "Spain")
portugal = Region.create(name: "Portugal")
morocco = Region.create(name: "Morocco")
algeria = Region.create(name: "Algeria")
tunisia = Region.create(name: "Tunisia")
belgium = Region.create(name: "Belgium")
holland = Region.create(name: "Holland")
denmark = Region.create(name: "Denmark")
norway = Region.create(name: "Norway")
sweden = Region.create(name: "Sweden")
west_balkan = Region.create(name: "West Balkan")
greece = Region.create(name: "Greece")
romania = Region.create(name: "Romania")
bulgaria = Region.create(name: "Bulgaria")
turkey = Region.create(name: "Turkey")

puts "Creating sea regions..."

baltic_sea = Region.create(name: "Baltic Sea", land: false)
north_sea = Region.create(name: "North Sea", land: false)
north_atlantic = Region.create(name: "North Atlantic", land: false)
english_channel = Region.create(name: "English Channel", land: false)
bay_of_biscay = Region.create(name: "Bay of Biscay", land: false)
western_mediterranean_sea = Region.create(name: "Western Mediterranean Sea", land: false)
ionian_sea = Region.create(name: "Ionian Sea", land: false)
black_sea = Region.create(name: "Black Sea", land: false)

puts "Populating neighboring regions..."

dublin.update!(neighbors: [north_atlantic])
edinburgh.update!(neighbors: [north_sea, edinburgh, sheffield])
liverpool.update!(neighbors: [north_atlantic, edinburgh, sheffield, london])
sheffield.update!(neighbors: [edinburgh, liverpool, london, north_sea])
london.update!(neighbors: [liverpool, sheffield, english_channel])
brest.update!(neighbors: [english_channel, paris, bordeaux, dijon])
paris.update!(neighbors: [brest, dijon, belgium])
dijon.update!(neighbors: [munich, marseille, bordeaux, brest, paris, belgium])
bordeaux.update!(neighbors: [bay_of_biscay, brest, dijon, spain, marseille])
marseille.update!(neighbors: [spain, bordeaux, dijon, genoa, western_mediterranean_sea])
hamburg.update!(neighbors: [denmark, north_sea, holland, berlin, cologne])
berlin.update!(neighbors: [hamburg, cologne, munich, prague, danzig])
danzig.update!(neighbors: [berlin, prague, baltic_sea, warsaw])
cologne.update!(neighbors: [])
munich.update!(neighbors: [])
st_petersburg.update!(neighbors: [])
moscow.update!(neighbors: [])
warsaw.update!(neighbors: [])
kiev.update!(neighbors: [])
odessa.update!(neighbors: [])
prague.update!(neighbors: [])
lemberg.update!(neighbors: [])
vienna.update!(neighbors: [])
budapest.update!(neighbors: [])
trieste.update!(neighbors: [])
genoa.update!(neighbors: [])
venice.update!(neighbors: [])
florence.update!(neighbors: [])
rome.update!(neighbors: [])
naples.update!(neighbors: [])
spain.update!(neighbors: [portugal, bordeaux, marseille])
portugal.update!(neighbors: [])
morocco.update!(neighbors: [])
algeria.update!(neighbors: [])
tunisia.update!(neighbors: [])
belgium.update!(neighbors: [])
holland.update!(neighbors: [])
denmark.update!(neighbors: [])
norway.update!(neighbors: [])
sweden.update!(neighbors: [])
west_balkan.update!(neighbors: [])
greece.update!(neighbors: [])
romania.update!(neighbors: [])
bulgaria.update!(neighbors: [])
turkey.update!(neighbors: [])
baltic_sea.update!(neighbors: [])
north_sea.update!(neighbors: [])
north_atlantic.update!(neighbors: [])
english_channel.update!(neighbors: [])
bay_of_biscay.update!(neighbors: [])
western_mediterranean_sea.update!(neighbors: [])
ionian_sea.update!(neighbors: [])
black_sea.update!(neighbors: [])
