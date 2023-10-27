require './Station.rb'
require './Route.rb'
require './Train.rb'

def list_trains_at(station)
  puts "На станции #{station.name}" if station.trains.count > 0
  station.trains.each{|train| puts "Поезд №#{train.number}, #{train.type}, #{train.van_count}"+(train.route ? " #{train.route.stations.first.name} - #{train.route.stations.last.name}" : "")}
end

def list_trains_at_all(stations)
  stations.each{|key, station| list_trains_at(station)}  
end


stations = {}
stations[:MSK] =  Station.new('Москва')
stations[:SPB] = Station.new('Санкт-Питербург')
stations[:RND] = Station.new('Ростов-на-Дону')
stations[:KRD] = Station.new('Краснодар')
stations[:SCH] = Station.new('Сочи')
stations[:ADL] = Station.new('Адлер')


route101 = Route.new(stations[:MSK],stations[:ADL])
route101.add(stations[:RND])
route101.add(stations[:KRD])
route101.add(stations[:SCH])

route102 = Route.new(stations[:ADL],stations[:MSK])
route102.add(stations[:SCH])
route102.add(stations[:KRD])
route102.add(stations[:RND])


route107 = Route.new(stations[:SPB],stations[:KRD])
route107.add(stations[:RND])

route108 = Route.new(stations[:KRD],stations[:SPB])
route108.add(stations[:RND])


train8001 = Train.new(8001,:passanger,10)
train8002 = Train.new(8002,:passanger,10)
train911 = Train.new(911,:cargo,1)
train112 = Train.new(112,:cargo,2)


train8001.set_route(route101)
puts "#{train8001}"

train8002.set_route(route102)
stations[:MSK].arrive(train911)
stations[:SPB].arrive(train112)


list_trains_at_all(stations)

puts "\n=Поезд 8001 отправился"
train8001.move_up

list_trains_at_all(stations)

puts "\n=Поезд 8001 отправился"
train8001.move_up

list_trains_at_all(stations)

