class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def arrive(train)
    @trains << train
    train.set_station(self)
  end

  def depart(train)
    @trains.delete(train)
  end

  def by_type(type)
    trains.select {|t| t.type == type}
  end

  def list
    puts "Поезда на станции #{@name}"
    trains.each {|t| puts " №#{t.number} #{t.type} =#{t.van_count}"}
  end
end #class Station


class Route
  attr_reader :stations

  def initialize(first, last)
    @stations = [first, last]
  end

  def add(pos = -2, station)
    @stations.insert(pos, station)
  end

  def remove(station)
    @stations.delete(station)
  end

  def print
    @stations.each {|s| puts s.name}
  end
end #class Route


class Train
  $TRAIN_TYPES=[:passanger, :cargo]
  attr_reader :number, :type, :van_count, :speed, :route, :station

  def initialize(number,type,van_count)
    @number = number
    @type = type
    @van_count = van_count
    @speed = 0
  end

  def accelerate(delta_v)
    @speed += delta_v if delta_v > 0
  end

  def slow(delta_v)
    @speed -= delta_v if delta_v > 0
    stop if @speed < 0
  end

  def stop
    @speed = 0
  end

  def hook_van
    @van_count += 1 if @speed == 0
  end

  def unhook_van
    @van_count -= 1 if @speed == 0 && @van_count > 0
  end

  def set_route(route)
    @route = route
    @station.depart(self) if @station
    @station = route.stations.first
    @station.arrive(self)
  end

  def move_up
    if @route && @station != @route.stations.last
      @station.depart(self)
      @station = next_station
      @station.arrive(self)
    end
  end

  def move_down
    if @route && @station != @route.stations.first
      @station.depart(self)
      @station = prev_station
      @station.arrive(self)
    end
  end

  def next_station
    @route.stations[@route.stations.index(@station)+1]
  end    

  def prev_station
    @route.stations[@route.stations.index(@station)-1]
  end

  def set_station (station)
    @station = station
  end
end #class Train
