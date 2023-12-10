require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'trains/train.rb'
require_relative 'trains/cargo_train.rb'
require_relative 'trains/passenger_train.rb'
require_relative 'vans/van.rb'
require_relative 'vans/cargo_van.rb'
require_relative 'vans/passenger_van.rb'

class MainCLI
  attr_accessor :vans, :routes

  ERROR_WRONG_COMMAND = "\033[0;31mНеверная команда!\033[0m Смотрите справку: \033[0;32mhelp\033[0m"
  ERROR_WRONG_TYPE = "\033[0;31mНеверный тип!\033[0m Допустимые типы: \033[0;32mcargo passenger\033[0m"
  ERROR_WRONG_STATION = "\033[0;31mСтанция не найдена!\033[0m"
  ERROR_WRONG_TRAIN = "\033[0;31mПоезд не найден!\033[0m"
  ERROR_WRONG_VAN = "\033[0;31mВагон не найден!\033[0m"
  ERROR_WRONG_VAN_TYPE = "\033[0;31mНеизвестный тип вагона!\033[0m"
  PROMT = "\033[0;32m> "
  PROMT_END = "\033[0m"

  def initialize
    @vans = []
    @routes = []
  end

  def ask(question, default_answer=nil)
    print(question)
    answer = gets.chomp.to_s
    answer.empty? ? default_answer : answer
  end

  def ask_i(question, default_answer='0')
    ask(question, default_answer).to_i
  end

  #Цветной вывод https://stackoverflow.com/questions/1489183/how-can-i-use-ruby-to-colorize-the-text-output-to-a-terminal
  COLORS = {:default => "38", :black => "30", :red => "31", :green => "32", :brown => "33", :blue => "34", :purple => "35",
    :cyan => "36", :gray => "37", :dark_gray => "1;30", :light_red => "1;31", :light_green => "1;32", :yellow => "1;33",
    :light_blue => "1;34", :light_purple => "1;35", :light_cyan => "1;36", :white => "1;37"}
  BG_COLORS = {:default => "0", :black => "40", :red => "41", :green => "42", :brown => "43", :blue => "44",
    :purple => "45", :cyan => "46", :gray => "47", :dark_gray => "100", :light_red => "101", :light_green => "102",
    :yellow => "103", :light_blue => "104", :light_purple => "105", :light_cyan => "106", :white => "107"}

  def colorize(text, color = :default, bgColor = :default)
    color_code = COLORS[color]
    bgColor_code = BG_COLORS[bgColor]
    "\033[#{bgColor_code};#{color_code}m#{text}\033[0m"
  end

  def col_command(str)
    colorize(str, :green)
  end

  def col_param(str)
    colorize(str, :light_red)
  end
  
  def col_title(str)
    colorize(str, :cyan)
  end
  
  def col_subtitle(str)
    colorize(str, :default, :dark_gray)
  end

  def col_count(str)
    colorize(str, :purple)
  end
  
  def col_comment(str)
    colorize(str, :default)
  end
  
  def col_error(str)
      colorize(str, :red)
  end


  #ACTIONS
  def show_help 
    puts
    puts col_title '=== Управление железной дорогой ==='
    puts "#{col_subtitle 'Станции'} #{col_count "(#{Station.instances})"}"
    puts "  #{col_command 'new station'} #{col_param '<name>'}                                      #{col_comment 'Создать новую станцию'}"
    puts "  #{col_command 'show station'} #{col_param '<name>'}                                     #{col_comment 'Показать подробную информацию о станции'}"
    puts "  #{col_command 'list stations'}                                           #{col_comment 'Показать список всех станций'}"
    puts "  #{col_command 'delete station'} #{col_param '<name>'}                                   #{col_comment 'Удалить станцию'}"
    puts "#{col_subtitle 'Поезда'} #{col_count "(#{Train.all.count})"}"
    puts "  #{col_command 'new train'} #{col_command '[cargo]|[passanger]'} #{col_param '<number>'} #{col_param '[manufacturer]'}   #{col_comment 'Создать новый поезд'}"
    puts "  #{col_command 'show train'} #{col_param '<number>'}                                     #{col_comment 'Показать подробную информацию о поезде'}"
    puts "  #{col_command 'list trains'}                                             #{col_comment 'Показать список всех поездов'}"
    puts "  #{col_command 'delete train'} #{col_param '<number>'}                                   #{col_comment 'Удалить поезд'}"
    puts "  #{col_command 'train'} #{col_param '<number>'} #{col_command 'hook'} #{col_param '<van number>'}                        #{col_comment 'Прицепить вагон'}"
    puts "  #{col_command 'train'} #{col_param '<number>'} #{col_command 'unhook'} #{col_param '<van number>'}                      #{col_comment 'Отцепить вагон'}"
    puts "  #{col_command 'train'} #{col_param '<number>'} #{col_command 'route'} #{col_param '<number>'}                           #{col_comment 'Установить маршрут #'}"
    puts "  #{col_command 'train'} #{col_param '<number>'} #{col_command 'move up'}                                  #{col_comment 'Переместить поезд вперед по маршруту'}"
    puts "  #{col_command 'train'} #{col_param '<number>'} #{col_command 'move down'}                                #{col_comment 'Переместить поезд назад по маршруту'}"
    puts "  #{col_command 'train'} #{col_param '<number>'} #{col_command 'move station'} #{col_param '<name>'}                      #{col_comment 'Переместить поезд на станцию'}"
    puts "#{col_subtitle 'Вагоны'} #{col_count "(#{vans.count})"}"
    puts "  #{col_command 'new van [cargo]|[passanger]'} #{col_param '<number>'} #{col_param '[manufacturer]'} #{col_param '<?>'} #{col_comment 'Создать новый вагон'}"
    puts "                                 Где #{col_param '<?>'} это:  #{col_param '<seats>'}  - для пассажирского вагона"
    puts "                                               #{col_param '<volume>'} - для грузового вагона"
    puts "  #{col_command 'show van'} #{col_param '<number>'}                                       #{col_comment 'Показать подробную информацию о вагоне'}"
    puts "  #{col_command 'list vans'}                                               #{col_comment 'Показать список всех вагонов'}"
    puts "  #{col_command 'delete van'} #{col_param '<number>'}                                     #{col_comment 'Удалить вагон'}"
    puts "  #{col_command 'train take'} #{col_param '<van_number>'} #{col_param '[<seats>|<volume>]'}              #{col_comment 'Получить место в пассажирском вагоне или заполнить грузовой'}"
    puts "#{col_subtitle 'Маршруты'} #{col_count "(#{routes.count})"}"
    puts "  #{col_command 'new route'} #{col_param '<A>'}#{col_command ';'}#{col_param '<B>'}                                       #{col_comment 'Создать новый маршрут из станции А до станции В'}"
    puts "  #{col_command 'show route'} #{col_param '<#number>'}                                    #{col_comment 'Показать подробную информацию о маршруте'}"
    puts "  #{col_command 'list routes'}                                             #{col_comment 'Показать список всех маршрутов'}"
    puts "  #{col_command 'delete route'} #{col_param '<#number>'}                                  #{col_comment 'Удалить маршрут'}"
    puts "  #{col_command 'route'} #{col_param '<#number>'} #{col_command 'add'} #{col_param '<station>'}                           #{col_comment 'Добавить станцию'}"
    puts
    puts "  #{col_command 'fill'}                                                   #{col_comment 'Добавить тестовые данные'}" 
    puts "  #{col_command 'show all'}                                               #{col_comment 'Показать все станции и поезда на них'}" 
    puts "  #{col_command 'help'}    #{col_comment 'Показать справку по командам'}"
    puts "  #{col_command 'exit'}    #{col_comment 'Выход'}"
  end

  def represent_train(train)
    "Поезд \##{train.number} (#{train.type}) by #{train.manufacturer}: скорость #{train.speed}км/ч, вагонов #{train.vans.count}, станция #{train.station}, маршрут #{train.route}"
  end

  def represent_train_simple(train)
    "\##{train.number} #{train.type} #{train.vans.count}"
  end

  def represent_van(van)
    str = "Вагон #{van.number} #{van.type} by #{van.manufacturer} #{van.train.nil? ? 'отцеплен' : van.train.number}"
    case van.type
    when :cargo
      str += " объем (#{van.volume[:used]}/#{van.volume[:total]})"
    when :passenger
      str += " мест (#{van.seats[:used]}/#{van.seats[:total]})"
    end
  end

  def represent_van_simple(van)
    str = "#{van.number} #{van.type}"
    case van.type
    when :cargo
      str += " #{van.volume[:used]}/#{van.volume[:total]}"
    when :passenger
      str += " #{van.seats[:used]}/#{van.seats[:total]}"
    end
  end

  def represent_station(station)
    station.name
  end

  def represent_route(route)
    "[#{route.stations.map{ |st| st.name }.join '-'}]"
  end

  def new_train(number, type, manufacturer = nil)
    case type 
    when :cargo
      CargoTrain.new(number, manufacturer)
    when :passenger
      PassengerTrain.new(number, manufacturer)
    end
    puts "\##{Train.all.count-1}: #{represent_train(Train.all.last)}"
  end

  def new_van(number, type, manufacturer = nil, total)
    case type
    when :cargo then vans << CargoVan.new(number, manufacturer, total)
    when :passenger then vans << PassengerVan.new(number, manufacturer, total)
    end
    puts "\##{vans.count-1}: #{represent_van(vans.last)}"
  end

  def new_route(stations_names)
    station_a = Station.all.select{ |station| station.name == stations_names.first}.first
    station_b = Station.all.select{ |station| station.name == stations_names.last}.first
    route = Route.new(station_a, station_b)
    if stations_names.count > 2
      stations_names[1..-2].each { |st_name| route.add(Station.all.select{ |station| station.name == st_name }.first) }   
    end
    routes << route
    puts "\##{routes.count-1}: #{represent_route(routes.last)}"    
  end

  def show_station(name)
    station = Station.all.select{ |station| station.name==name}.first
    puts "=#{station}="
    station.trains.each { |train| puts represent_train(train)}
  end

  def show_train(number)
    train = Train.find(number)
    if train.nil?
      puts ERROR_WRONG_TRAIN
      return
    end
    puts "=#{represent_train(train)}="
    train.vans.each { |van| puts represent_van(van) }
  end

  def show_van(number)
    van = vans.select{| van| van.number==number}.first
    puts represent_van(van)
  end


  #MENU
  def menu_new_station(choice_arr)
    if choice_arr.count >= 1
      station_name=choice_arr.join(' ')
      station = Station.new(station_name)
      puts "\##{Station.all.count-1}: #{represent_station(station)}"
    else
      puts ERROR_WRONG_COMMAND
    end
  end

  def menu_new_train(choice_arr)
    if choice_arr.count >= 2
      type_str = choice_arr.shift.upcase
      number = choice_arr.shift
      manufacturer = (choice_arr.count > 0) ? choice_arr.join(' ') : nil

      case type_str
      when 'C','CARGO'
        type = :cargo
      when 'P', 'PASSENGER' 
        type = :passenger
      else
        puts ERROR_WRONG_TYPE
        return
      end

      new_train(number, type, manufacturer)
    else
      puts ERROR_WRONG_COMMAND
    end
  end

  def menu_new_van(choice_arr)
    if choice_arr.count >= 3
      type_str = choice_arr.shift.upcase
      number = choice_arr.shift.to_i
      total = choice_arr.pop.to_i
      manufacturer = (choice_arr.count > 0) ? choice_arr.join(' ') : nil

      case type_str
      when 'C','CARGO'
        type = :cargo
      when 'P', 'PASSENGER' 
        type = :passenger
      else
        puts ERROR_WRONG_TYPE
        return
      end

      new_van(number, type, manufacturer, total)
    else
      puts ERROR_WRONG_COMMAND
    end
  end

  def menu_new_route(choice_arr)
    if choice_arr.count >=1
      new_route(choice_arr.join(' ').split(';'))
    else
      puts ERROR_WRONG_COMMAND
    end
  end

  def menu_new(choice_arr)
    choice_current = choice_arr.shift.upcase
    case choice_current
    when 'S', 'STATION'
     menu_new_station(choice_arr)
    when 'T', 'TRAIN'
      menu_new_train(choice_arr)
    when 'V', 'VAN'
      menu_new_van(choice_arr)
    when 'R', 'ROUTE'
      menu_new_route(choice_arr)
    else
      puts ERROR_WRONG_COMMAND
    end 
  end

  def show_all
    Station.all.each do |station|
      puts "===[#{represent_station(station)}]==="
      station.trains_info do |train|
        puts "  #{represent_train_simple(train)}"
        train.vans_info do |van|
          puts "    #{represent_van(van)}"
        end
      end
    end
  end

  def menu_show(choice_arr)
    choice_current = choice_arr.shift.upcase
    case choice_current
    when 'S', 'STATION'
      show_station(choice_arr.join(' '))
    when 'T', 'TRAIN'
      show_train(choice_arr.first)
    when 'V', 'VAN'
      show_van(choice_arr.first.to_i)
    when 'R', 'ROUTE'
      puts represent_route(routes[(choice_arr.first.to_i)])
    when 'A', 'ALL'
      show_all
    else
      puts ERROR_WRONG_COMMAND
    end
  end

  def menu_list(choice_arr)
    case choice_arr.first.upcase
    when 'S', 'STATIONS'
      Station.all.each { |st| puts represent_station(st)}
    when 'T', 'TRAINS'
      Train.all.each { |tr| puts represent_train(tr)} 
    when 'V', 'VANS'
      vans.each { |vn| puts represent_van(vn)}
    when 'R', 'ROUTES'
      routes.each_with_index { |rt, n| puts "#{n} #{represent_route(rt)}" }
    else
      puts ERROR_WRONG_COMMAND
    end
  end

  def menu_delete(choice_arr)
    choice_current = choice_arr.shift.upcase
    case choice_current
    when 'S', 'STATION'
      station = Station.all.select { |st| st.name==choice_arr.join(' ')}.first
      station.destroy
      #Код ниже должен быть после перемещения поезда. В будущем убрать внутрь destroy, после доработки класса Route.
      routes.each do |route| 
                    route.stations.delete(station)
                    routes.delete(route) if route.stations.count == 0
                  end
      puts 'Станция удалена'
    when 'T', 'TRAIN'
      train = Train.all.select { |tr| tr.number==choice_arr.first.to_i}.first
      train.vans.each { |van| van.unhook }
      train.station.depart(train) if train.station
      train.destroy
      puts 'Поезд удален'
    when 'V', 'VAN'
      van = vans.select { |van| van.number==choice_arr.first.to_i}.first
      van.unhook if van.train
      vans.delete(van)
      puts 'Вагон удален'
    when 'R', 'ROUTE'
      route = routes[choice_arr.first.to_i]
      Train.all.each { |train| train.set_route(nil) if train.route == route}
      routes.delete(route)
      puts 'Маршрут удален'
    else
      puts ERROR_WRONG_COMMAND
    end
  end

  def menu_train_hook(train, choice_arr)
    number = choice_arr.first.to_i
    van = vans.select { |vn| vn.number == number }.first
    train.hook(van)
    puts "Вагон успешно прицеплен"
  end

  def menu_train_unhook(train, choice_arr)
    number = choice_arr.first.to_i
    van = vans.select { |vn| vn.number == number }.first
    train.unhook(van)
    puts "Вагон успешно отцеплен"
  end

  def menu_train_move(train, choice_arr)
    number = choice_arr.first.to_i
    direction = choice_arr.shift.upcase
    case direction
    when 'U', 'UP'
      train.move_up
      puts "Поезд №#{train.number} на станции #{represent_station(train.station)}"
    when 'D', 'DOWN' 
      train.move_down
      puts "Поезд №#{train.number} на станции #{represent_station(train.station)}"
    when 'S', 'STATION'
      st_name = choice_arr.join(' ')
      station = Station.all.select { |station| station.name == st_name }.first
      train.set_station(station)
      puts "Поезд №#{train.number} прибыл на станцию #{represent_station(station)})"
    else
      puts ERROR_WRONG_COMMAND
    end
  end

  def menu_train_route(train, choice_arr)
    n = choice_arr.first.to_i
    train.set_route(routes[n])
    puts "Поезду назначен на маршрут"
  end

  def menu_train_take(choice)
    number = choice.shift.to_i
    count = choice.shift.to_i
    van = vans.select { |van| van.number == number }.first
    unless van.nil?
      case van.type
      when :passenger
        taked = 0
        used_before = van.used_seats
        begin
          count.times do 
            van.take_seat
            taked += 1
          end
        rescue NotEnoughFreeSeats
          deficit = true
        end
        used_after = van.used_seats
        puts "Занято мест: #{taked}"
        puts "Не хватило мест: #{count - taked}" if deficit

      when :cargo
        used_before = van.used_volume
        begin
          van.take_volume(count)
          used_after = van.used_volume
          taked = used_after - used_before
          puts "Занят объем: #{taked}"
        rescue NotEnoughFreeSpace
          oversize = count - van.used_volume
          puts "Не удалось разместить груз, недостаточно #{oversize}"
        end
      else
        puts ERROR_WRONG_VAN_TYPE
      end
    else
      puts ERROR_WRONG_VAN
    end
  end

  def menu_train(choice_arr)
    word = choice_arr.shift
    case word.upcase 
    when 'T', 'TAKE'
      menu_train_take(choice_arr)
    else
      number = word
      train = Train.find(number)
      if train.nil?
        puts ERROR_WRONG_TRAIN
        return
      end
      choice_current = choice_arr.shift.upcase
      case choice_current
      when 'H', 'HOOK'
        menu_train_hook(train, choice_arr)
      when 'U', 'UNHOOK'
        menu_train_unhook(train, choice_arr)
      when 'M', 'MOVE'
        menu_train_move(train, choice_arr)
      when 'R', 'ROUTE'
        menu_train_route(train, choice_arr)
      else
        puts ERROR_WRONG_COMMAND
      end
    end
  end  

  def menu_route_add(route, stations_names_str)
    stations_names = stations_names_str.split(';')
    stations_names.each { |name| route.add(Station.all.select{|st| st.name == name}.first) }
  end

  def menu_route(choice_arr)
    n = choice_arr.shift.to_i
    route = routes[n]
    choice_current = choice_arr.shift.upcase
    case choice_current
    when 'A', 'ADD'    
      menu_route_add(route, choice_arr.join(' '))
      puts represent_route(route)
    else
      puts ERROR_WRONG_COMMAND
    end
  end

  def fill_sample_data
    menu('new train passenger 101 Людиновский ТВСЗ')
    menu('new van passenger 1101 Метровагонмаш 40')
    menu('new van passenger 1102 Метровагонмаш 44')
    menu('new van passenger 1103 Метровагонмаш 44')
    menu('new van passenger 1104 Метровагонмаш 44')
    menu('new van passenger 1105 Метровагонмаш 44')
    menu('new van passenger 1106 Метровагонмаш 44')
    menu('new van passenger 1107 Метровагонмаш 44')
    menu('new van passenger 1108 Метровагонмаш 42')
    menu('train 101 hook 1101')
    menu('train 101 hook 1102')
    menu('train 101 hook 1103')
    menu('train 101 hook 1104')
    menu('train 101 hook 1105')
    menu('train 101 hook 1106')
    menu('train 101 hook 1107')
    menu('train 101 hook 1108')
    menu('train take 1101 10')
    menu('train take 1102 20')
    menu('train take 1103 1')
    menu('train take 1104 2')
    
    menu('new train passenger 102-FF Людиновский ТВСЗ')
    menu('new van passenger 1201 Метровагонмаш 40')
    menu('new van passenger 1202 Метровагонмаш 44')
    menu('new van passenger 1203 Метровагонмаш 44')
    menu('new van passenger 1204 Метровагонмаш 44')
    menu('new van passenger 1205 Метровагонмаш 44')
    menu('new van passenger 1206 Метровагонмаш 44')
    menu('new van passenger 1207 Метровагонмаш 44')
    menu('new van passenger 1208 Метровагонмаш 42')
    
    menu('train 102-FF hook 1201')
    menu('train 102-FF hook 1202')
    menu('train 102-FF hook 1203')
    menu('train 102-FF hook 1204')
    menu('train 102-FF hook 1205')
    menu('train 102-FF hook 1206')
    menu('train 102-FF hook 1207')
    menu('train 102-FF hook 1208')

    menu('new train passenger 103 Новочеркасский ЭВСЗ')
    menu('new van passenger 1301 Тверской ВСЗ 64')
    menu('new van passenger 1302 Тверской ВСЗ 54')
    menu('new van passenger 1303 Тверской ВСЗ 81')
    menu('new van passenger 1304 Тверской ВСЗ 36')
    menu('train 103 hook 1301')
    menu('train 103 hook 1302')
    menu('train 103 hook 1303')
    menu('train 103 hook 1304')
    
    menu('new train cargo 104 Коломенский завод')
    menu('new van cargo 1401 Канашский ВРЗ 80')
    menu('new van cargo 1402 Канашский ВРЗ 60')
    menu('new van cargo 1403 Канашский ВРЗ 60')
    menu('new van cargo 1404 Канашский ВРЗ 40')
    menu('new van cargo 1405 Канашский ВРЗ 40')
    menu('new van cargo 1406 Канашский ВРЗ 40')
    
    menu('train 104 hook 1401')
    menu('train 104 hook 1402')
    menu('train 104 hook 1403')
    menu('train 104 hook 1404')
    menu('train 104 hook 1405')
    menu('train 104 hook 1406')
    
    menu('new train cargo 105 Людиновский ТВСЗ')
    menu('new train passenger 106 Уралтрансмаш')
    menu('new train passenger 107 Уралтрансмаш')
    menu('new van cargo 1501 100')
    menu('new van passenger 1601 100')
    
    menu('new station Москва')
    menu('new station Питер')
    menu('new station Ростов')
    menu('new station Краснодар')
    menu('new station Сочи')
    menu('new station Адлер')
    menu('new station Абинск')
    menu('new station Крымск')
    menu('new station Новороссийск')
    menu('new station Новокузнецк')
    menu('new station Челябинск')
    menu('new station Крымск')
    
    menu('new route Москва;Ростов;Краснодар;Сочи;Адлер')
    menu('new route Москва;Питер')
    menu('new route Краснодар;Абинск;Крымск;Новороссийск')
    menu('new route Краснодар;Сочи;Адлер')
    menu('new route Челябинск;Новокузнецк;Краснодар;Сочи')
    
    menu('train 101 route 0')
    menu('train 102-FF route 1')
    menu('train 103 route 2')
    menu('train 105 route 3')
    menu('train 106 route 4')
    menu('train 107 route 5')
  
    3.times { menu('train 101 move up') }
    4.times { menu('train 102-FF move up') }
  end

  def menu(choice)
    choice_arr = choice.split(' ')
    
    if choice_arr.count >= 1
      choice_current = choice_arr.shift.upcase
      case choice_current
      when 'E', 'EXIT'    then return true
      when 'H', 'HELP'    then show_help
      when 'N', 'NEW'     then menu_new(choice_arr)
      when 'S', 'SHOW'    then menu_show(choice_arr)
      when 'L', 'LIST'    then menu_list(choice_arr)
      when 'D', 'DELETE'  then menu_delete(choice_arr)
      when 'T', 'TRAIN'   then menu_train(choice_arr)
      when 'R', 'ROUTE'   then menu_route(choice_arr)
      when 'F', 'FILL'    then fill_sample_data
      else
        puts ERROR_WRONG_COMMAND
      end
    end
    false
  end

  def start()
    loop do
      choice = ask PROMT
      print PROMT_END
      
      unless choice.nil?
        break if menu(choice)
      end
    end
  end

end #class MainCLI


puts "Thinknetica: Управление ЖД\n(c)2023 Anton Kokarev\n\nВведите help для справки"
menu = MainCLI.new

normal_exit = false
while !normal_exit do 
  begin
    menu.start
    normal_exit = true

  rescue  StandardError => e
    puts e.inspect
    puts e.backtrace
    retry
  end
end
