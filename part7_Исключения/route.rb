class Route
  attr_reader :stations

  def initialize(first, last)
    @stations = [first, last]
  end

  def add(pos = -2, new_station)
    self.stations.insert(pos, new_station) if new_station
  end

  def remove(old_station)
    self.stations.delete(old_station)
  end

  def to_s
     "[#{self.stations.join '-'}]"
  end

end
