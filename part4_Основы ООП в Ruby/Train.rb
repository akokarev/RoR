class Train
  attr_reader :number, :type, :van_count, :speed, :route
  attr_accessor :station

  def initialize(number, type, van_count)
    @number = number
    @type = type
    @van_count = van_count
    @speed = 0
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

  def hook_van
    van_count += 1 if speed == 0
  end

  def unhook_van
    van_count -= 1 if speed == 0 && van_count > 0
  end

  def set_route(route)
    @route = route
    station.depart(self) if @station
    station = route.stations.first
    station.arrive(self)
  end

  def move_up
    if route && station != route.stations.last
      station.depart(self)
      station = next_station
      station.arrive(self)
    end
  end

  def move_down
    if route && station != route.stations.first
      station.depart(self)
      station = prev_station
      station.arrive(self)
    end
  end

  def next_station
    route.stations[route.stations.index(station)+1]
  end    

  def prev_station
    route.stations[route.stations.index(station)-1]
  end
end