class Train
  attr_reader :number, :vans, :speed, :route, :station

  def type 
    raise NotImplementedError
  end

  def initialize(number)
    type
    @number = number
    @vans = []
    @speed = 0
  end

  def set_station(new_station)
    if station != new_station
      old_station = @station
      station = new_station
      old_station.depart(self) if old_station
      new_station.arrive(self) if new_station
    end
  end

  def accelerate(delta_speed)
    speed += delta_speed if delta_speed > 0
  end

  def slow(delta_speed)
    speed -= delta_speed if delta_speed > 0
    stop if @speed < 0
  end

  def stop
    speed = 0
  end

  def hook(new_van)
    raise 'Вагон должен быть указан' unless new_van.kind_of? Van
    raise 'Тип поезда не соответсвует типу вагона' unless self.type == new_van.type
    raise 'Вагон нельзя прицепить дважды' if vans.include?(new_van)
    raise 'Нельзя прицепить вагон во время движения поезда' unless self.speed == 0

    vans << new_van
    new_van.hook(self) unless new_van.train == self
  end

  def unhook(old_van)
    raise 'Вагон не был прицеплен' unless vans.include?(old_van) 
    raise 'Нельзя отцепить вагон во время движения поезда' unless self.speed == 0
    vans.delete(old_van)
    old_van.unhook if old_van.train == self
  end

  def set_route(new_route)
    route = new_route
    self.set_station(route.stations.first)
  end

  def move_up
    if route && station != route.stations.last
      set_station(next_station)
    end
  end

  def move_down
    if route && station != route.stations.first
      set_station(prev_station)
    end
  end

  def next_station
    route.stations[route.stations.index(station)+1]
  end    

  def prev_station
    route.stations[route.stations.index(station)-1]
  end

  def current_station
    station
  end

  def to_s
    "Поезд \##{number} (#{type}): скорость #{speed}км/ч, вагонов #{vans.count}, станция #{station}, маршрут #{route}"
  end

private
attr_writer :vans, :speed, :route, :station

end
