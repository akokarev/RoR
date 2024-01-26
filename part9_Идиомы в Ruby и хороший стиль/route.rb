# Класс маршрутов движения поездов
class Route
  attr_reader :stations

  def validate!
    stations.each do |station|
      raise TypeError, 'Станция должна быть типа Station' unless station.is_a? Station
      raise InvalidStation, 'Станции в маршруте должны быть валидные' unless station.valid?
    end
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def initialize(first, last)
    @stations = [first, last]
    validate!
  end

  def add(new_station, pos = -2)
    stations.insert(pos, new_station) if new_station
  end

  def remove(old_station)
    stations.delete(old_station)
  end
end
