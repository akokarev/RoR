class Route
  attr_reader :stations

  def initialize(first, last)
    @stations = [first, last]
  end

  def add(pos = -2, station)
    @stations.insert(pos, station)
  end

  def remove(station)
    stations.delete(station)
  end

  def list
    stations
  end
end