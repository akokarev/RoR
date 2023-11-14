require_relative '../manufacturer.rb'

class Train
  include Manufacturer
  attr_reader :number, :vans, :speed, :route, :station

  def type 
    raise NotImplementedError
  end

  def initialize(number)
    @number = number
    @vans = []
    @speed = 0
  end

  def set_station(new_station)
    if @station != new_station
      old_station = @station
      @station = new_station
      old_station.depart(self) if old_station
      new_station.arrive(self) if new_station
    end
    return @station
  end

  def accelerate(delta_speed)
    @speed += delta_speed if delta_speed > 0
  end

  def slow(delta_speed)
    @speed -= delta_speed if delta_speed > 0
    stop if @speed < 0
  end

  def stop
    @speed = 0
  end

  def van_count
    vans.count
  end

  def hook(van)
    raise 'Вагон должен быть указан' unless van.kind_of? Van
    raise 'Тип поезда не соответсвует типу вагона' unless self.type == van.type  
    raise 'Вагон нельзя прицепить дважды' if vans.include?(van)
    raise 'Нельзя прицепить вагон во время движения поезда' unless self.speed == 0

    vans << van
    van.hook(self) unless van.train == self
    return self
  end

  def unhook(van)
    raise 'Вагон не был прицеплен' unless vans.include?(van) 
    raise 'Нельзя отцепить вагон во время движения поезда' unless self.speed == 0
    vans.delete(van)
    van.unhook unless van.train == self
    return self
  end

  def set_route(route)
    @route = route
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
    @station
  end

private 
  attr_writer :speed, :station, :vans

end
