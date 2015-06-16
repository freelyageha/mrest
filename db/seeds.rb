# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Generate province
[[11,"서울시"], [26,"부산시"], [27,"대구시"], [28,"인천시"], [29,"광주시"], [30,"대전시"], [31,"울산시"], [36,"세종시"], [41,"경기도"], [42,"강원도"], [43,"충청북도"], [44,"충청남도"], [45,"전라북도"], [46,"전라남도"], [47,"경상북도"], [48,"경상남도"], [50,"제주도"]].each do |id, name|
  Province.find_or_create_by(id: id, name: name)
end
