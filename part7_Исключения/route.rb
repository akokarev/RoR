class Route
  attr_reader :stations

  def validate!
    self.stations.each do |station|
      raise 'Станция должна быть типа Station' unless station.kind_of? Station
      raise 'Станции в маршруте должны быть валидные' unless station.valid?
    end
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def initialize(first, last)
    @stations = [first, last]
    validate!
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
