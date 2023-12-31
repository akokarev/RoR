require_relative '../vans/van.rb'
require_relative '../modules/manufacturer.rb'
class Train
  include Manufacturer
  attr_reader :number, :vans, :speed, :route, :station

  @@trains = []
  
  class << self
    def all
      @@trains.clone
    end

    def find(number)
      @@trains.select { |train| train.number == number }.first
    end
  end

  def destroy
    @@trains.delete(self)
  end

  def type 
    raise NotImplementedError
  end

  def initialize(number, manufacturer = nil)
    @number = number
    @vans = []
    @speed = 0
    @manufacturer = manufacturer || 'NoName'
    @@trains << self
  end

  def set_station(new_station)
    if self.station != new_station
      old_station = self.station
      self.station = new_station
      old_station.depart(self) if old_station
      new_station.arrive(self) if new_station
    end
  end

  def accelerate(delta_speed)
    self.speed += delta_speed if delta_speed > 0
  end

  def slow(delta_speed)
    self.speed -= delta_speed if delta_speed > 0
    stop if self.speed < 0
  end

  def stop
    self.speed = 0
  end

  def hook(new_van)
    raise 'Вагон должен быть указан' unless new_van.kind_of? Van
    raise 'Тип поезда не соответсвует типу вагона' unless self.type == new_van.type
    raise 'Вагон нельзя прицепить дважды' if self.vans.include?(new_van)
    raise 'Нельзя прицепить вагон во время движения поезда' unless self.speed == 0

    self.vans << new_van
    new_van.hook(self) unless new_van.train == self
  end

  def unhook(old_van)
    raise 'Вагон не был прицеплен' unless self.vans.include?(old_van) 
    raise 'Нельзя отцепить вагон во время движения поезда' unless self.speed == 0
    self.vans.delete(old_van)
    old_van.unhook if old_van.train == self
  end

  def set_route(new_route)
    self.route = new_route
    set_station(new_route.stations.first) if new_route
  end

  def move_up
    if self.route && self.station != self.route.stations.last
      set_station(next_station)
    end
  end

  def move_down
    if self.route && self.station != self.route.stations.first
      set_station(prev_station)
    end
  end

  def next_station
    self.route.stations[self.route.stations.index(self.station)+1]
  end    

  def prev_station
    self.route.stations[self.route.stations.index(self.station)-1]
  end

  def to_s
    "Поезд \##{self.number} (#{self.type}) by #{self.manufacturer}: скорость #{self.speed}км/ч, вагонов #{self.vans.count}, станция #{self.station}, маршрут #{self.route}"
  end

  private
  attr_writer :vans, :speed, :route, :station

end
