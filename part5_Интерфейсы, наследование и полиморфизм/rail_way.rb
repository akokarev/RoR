require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'train.rb'
require_relative 'van.rb'
require_relative 'cargo_train.rb'
require_relative 'cargo_van.rb'
require_relative 'passenger_train.rb'
require_relative 'passenger_van.rb'

def list_trains_at(station)
  puts "На станции #{station.name}" if station.trains.count > 0
  station.trains.each{|train| puts "Поезд №#{train.number}, #{train.type}, #{train.van_count}"+(train.route ? " #{train.route.stations.first.name} - #{train.route.stations.last.name}" : "")}
end

def list_trains_at_all(stations)
  stations.each{|key, station| list_trains_at(station)}  
end


stations = {}
stations[:MSK] = Station.new('Москва')
stations[:SPB] = Station.new('Санкт-Питербург')
stations[:RND] = Station.new('Ростов-на-Дону')
stations[:KRD] = Station.new('Краснодар')
stations[:SCH] = Station.new('Сочи')
stations[:ADL] = Station.new('Адлер')
puts "\nСтанция :MSK #{stations[:MSK].inspect}"

route101 = Route.new(stations[:MSK],stations[:ADL])
route101.add(stations[:RND])
route101.add(stations[:KRD])
route101.add(stations[:SCH])
puts "\nМаршрут 101 #{route101.inspect}"

route102 = Route.new(stations[:ADL],stations[:MSK])
route102.add(stations[:SCH])
route102.add(stations[:KRD])
route102.add(stations[:RND])


route107 = Route.new(stations[:SPB],stations[:KRD])
route107.add(stations[:RND])

route108 = Route.new(stations[:KRD],stations[:SPB])
route108.add(stations[:RND])


train8001 = Train.new(8001,:passenger)
train8002 = PassengerTrain.new(8002,:passenger)

train112 = CargoTrain.new(112,:cargo)


van30001 = Van.new(30001, :cargo)
van30002 = CargoVan.new(30002)

van30003 = Van.new(30003, :passenger)
van30004 = PassengerVan.new(30004, :passenger)

begin
  van30005 = CargoVan.new(30005, :passenger)
  puts "ВНИМАНИЕ! Грузовой вагон имеет тип пассажирский"
  puts van30005.inspect
rescue
  puts "Тест пройден, Грузовой вагон не может быть пассажирским"
end

begin
  van30006 = PassengerVan.new(30006, :cargo)
  puts "ВНИМАНИЕ! Пассажирский вагон имеет тип грузовой"
  puts van30006.inspect
rescue
  puts "Тест пройден, Пассажирский вагон не может быть грузовым"
end


van30004.hook(train8001)

begin
  train8002.hook(van30001)
  puts "ВНИМАНИЕ! К пассажирскому поезду прицеплен грузовой вагон!"
  puts train8002.inspect
rescue
  puts "Тест пройден, к пассажирскому поезду нельзя прицепить грузовой вагон"
end

begin
  van30002.hook(train8002)
  puts "ВНИМАНИЕ! Пассажирский вагон прицеплен к грузовому поезду!"
  puts van30002.inspect
rescue
  puts "Тест пройден, пассажирский вагон нельзя прицепить к грузовому поезду"
end

begin
  train8002.hook(111)
  puts "Внимание, к поезду прицеплен не вагон!"
  puts train8002.inspect
rescue
  puts "Тест пройден, к поезду цепляются только вагоны"
end


train8001.hook(van30003)
begin
  train8002.unhook(van30003)
  puts "ВНИМАНИЕ! Отцеплен вагон, который не был прицеплен!"
rescue
  puts "Тест пройден, неприцепленный вагон нельзя отцепить"
end

begin
  train8002.hook(van30003)
  puts "Вагон был прицеплен повторно"
rescue
  puts "Тест пройден, вагон нельзя прицепить дважды"
end

train8001.set_route(route101)

train8002.set_route(route102)
stations[:MSK].arrive(train112)
stations[:SPB].arrive(train112)

puts "\n"
list_trains_at_all(stations)

puts "\n=Поезд 8001 отправился 3 раза"
3.times { train8001.move_up }
list_trains_at_all(stations)

puts "\n=Поезд 8002 отправился 3 раза"
3.times { 
  train8002.move_up
}
list_trains_at_all(stations)

puts "\n=Поезд 8001 вернулся назад 2 раза"
2.times { 
  train8001.move_down
}
list_trains_at_all(stations)

puts "\n=Поезд 8001 вернулся назад 999 раз"
999.times { 
  train8001.move_down
}
list_trains_at_all(stations)

puts "\n=Поезд 8002 отправился 999 раза"
999.times { 
  train8002.move_up
}
list_trains_at_all(stations)


puts "\nПоезд 112 ускорился 15км"
train112.accelerate(15)
puts train112.speed

puts "\nПоезд 112 притормозил 10"
train112.slow(10)
puts train112.speed

puts "\nПоезд 112 остановился"
train112.stop
puts train112.speed


train911 = Train.new(911,:cargo)
van101 = Van.new(101, :cargo)
van102 = Van.new(102, :cargo)
van103 = Van.new(103, :cargo)
puts "\n==Поезд 911 вагонов: #{train911.van_count}"
train911.hook(van101)
puts "Прицепили вагон №101: #{train911.van_count}"
train911.hook(van102)
train911.hook(van103) 
puts "Прицепили вагоны №102 и №103: #{train911.van_count}"
van102.unhook
puts "Отцеплен вагон №102: #{train911.van_count}"
train911.unhook(van101)
puts "Отцеплен вагоны №101: #{train911.van_count}"

begin
  train911.speed = 999
  puts "ВНИМАНИЕ! Скорость поезда установлена напрямую"
rescue
  puts "Тест пройден, скорость поезда напрямую не установлена"
end

begin
  train911.station = stations[:SCH]
  puts "ВНИМАНИЕ! Станция поезда установлена напрямую"
rescue
  puts "Тест пройден, станция поезда напрямую не установлена"
end
