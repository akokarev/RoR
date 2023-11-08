require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'train.rb'
require_relative 'van.rb'
require_relative 'cargo_train.rb'
require_relative 'cargo_van.rb'
require_relative 'passenger_train.rb'
require_relative 'passenger_van.rb'
require_relative 'menu.rb'
require_relative 'ask.rb'

stations = []
trains = []
vans = []
routes = []


menu = Menu.new('Управление железной дорогой', [
  Menu.new('Станции', '1', [
    Menu.new('Показать', '1', -> { stations.each_with_index { |st, n| puts "\##{n} #{st.name}: #{st.trains.count} поездов" } } ),
    Menu.new('Добавить', '2', -> { stations << Station.new( ask 'Название новой станции: ' ) } ),
    Menu.new('Удалить', '3', -> { stations.delete_at( ask_i 'Удалить станцию #' ) } )
  ]),
  Menu.new('Поезда', '2', [
    Menu.new('Показать', '1', -> { trains.each_with_index { |tr, n| puts "\##{n} Поезд №#{tr.number} (#{tr.type}) =#{tr.station.name}= #{tr.speed}км/ч (#{tr.van_count} вагонов)" } } ),
    Menu.new('Добавить', '2', [
      Menu.new('Грузовой','1', -> { trains << CargoTrain.new( ask 'Номер поезда: ' ) } ),
      Menu.new('Пассажирский', '2', -> {trains << PassengerTrain.new( ask 'Номер поезда: ') } )
    ] ),
    Menu.new('Удалить', '3', -> { trains.delete_at( ask_i 'Удалить поезд #' ) } ),  #Поезд не должен быть на станции
    Menu.new('Прицепить вагон', '4', -> { trains[ ask_i 'Поезд #' ].hook( vans[ ask_i 'Вагон #' ] ) } ),
    Menu.new('Отцепить вагон', '5', -> { trains[ ask_i 'Поезд #' ].unhook( vans[ ask_i 'Вагон #' ] ) } ),
    Menu.new('Назначить маршрут', '6', -> { trains[ ask_i 'Поезд #' ].set_route( routes[ ask_i 'Маршрут #' ] ) } ),
    Menu.new('Отправить на станцию', '7', -> { trains[ ask_i 'Поезд #' ].set_station( stations[ ask_i 'Станция #' ] ) } )
  ]),
  Menu.new('Вагоны', '3', [
    Menu.new('Показать', '1', -> { vans.each_with_index { |vn, n| puts "\##{n} Вагон №#{vn.number} (#{vn.type}) =#{vn.train.number}=" } } ),
    Menu.new('Добавить', '2', [
      Menu.new('Грузовой','1', -> { vans << CargoVan.new( ask 'Номер вагона: ' ) } ),
      Menu.new('Пассажирский', '2', -> { vans << PassengerVan.new( ask 'Номер вагона: ' ) } )
    ] ),
    Menu.new('Удалить', '3', -> { vans.delete_at( ask_i 'Удалить вагон #' ) } ),  #Поезд не должен быть на станции
    Menu.new('Прицепить к поезду', '4', -> { vans[ ask_i 'Вагон #' ].hook( trains[ ask_i 'Поезд #' ] ) } )
  ]),
  Menu.new('Маршруты', '4', [
    Menu.new('Показать','1', -> { routes.each_with_index { |rt, n| puts "\##{n} #{rt.stations.map{ |st| st.name }.join '-'  }" } } ),
    Menu.new('Добавить','2', -> { routes << Route.new( stations[ ask_i 'Станция отправления #' ], stations[ ask_i 'Станция назначения #' ] ) }),
    Menu.new('Удалить','3', -> { routes.delete_at( ask_i 'Удалить станцию #' ) }),
    Menu.new('Добавить станцию','4', -> { routes[ ask_i 'Маршрут #' ].add( ask_i( 'Позиция (-2): ', -2 ), stations[ ask_i 'Станция #' ] ) } ),
    Menu.new('Убрать станцию','5', -> { routes[ ask_i 'Маршрут #' ].remove( stations[ ask_i 'Станция #' ] ) } )
    #Убрать поезд с маршрута
  ]),
  Menu.new('Движение', '5', [
    Menu.new('Поезд вперед по маршруту', '1', -> {
      train = trains[ ask_i 'Поезд #' ]
      output = "Поезд #{train.number} переместился со станции #{train.station.name}"
      train.move_up
      output +=" вперед на станцию #{train.station.name}."
      puts output
    }),
    Menu.new('Поезд назад по маршруту', '2', -> {
      train = trains[ ask_i 'Поезд #' ]
      output = "Поезд #{train.number} переместился со станции #{train.station.name}"
      train.move_down
      output +=" назад на станцию #{train.station.name}."
      puts output
    })
  ])
])

menu.run 
