require './station.rb'
require './route.rb'
require './train.rb'

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


train8001 = Train.new(8001,:passanger,10)
train8002 = Train.new(8002,:passanger,10)
train911 = Train.new(911,:cargo,1)
train112 = Train.new(112,:cargo,2)


train8001.set_route(route101)

train8002.set_route(route102)
stations[:MSK].arrive(train911)
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

puts "\n==Поезд 911 вагонов: #{train911.van_count}"
100.times { train911.hook_van }
puts "Добвили 100 вагонов: #{train911.van_count}"
11.times { train911.unhook_van }
puts "Убавили  11 вагонов: #{train911.van_count}"
999.times { train911.unhook_van }
puts "Убавили 999 вагонов: #{train911.van_count}"


puts

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
