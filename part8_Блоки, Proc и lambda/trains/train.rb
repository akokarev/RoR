require_relative '../vans/van.rb'
require_relative '../modules/manufacturer.rb'
require_relative '../exceptions.rb'
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

  def type 
    raise NotImplementedError
  end

  def validate_van!(van, recur = false)
    raise TypeError, 'Вагон должен быть наследником класса Van' unless van.kind_of? Van
    raise DifferentTypes, 'Тип вагона не соответсвует типу поезда' unless type == van.type
    raise InvalidVan, 'Вагон должен быть валидным' unless recur || van.valid?(true)
  end
  
  def validate!(recur=false)
    raise InvalidTrainNumber, 'Номер поезда должен быть в формате 1ЯZ-2X' if number !~ /\A[\w\p{Cyrillic}]{3}(-[\w\p{Cyrillic}]{2}){0,1}\z/ 
    raise InvalidManufacturer, 'Производитель строка минимум 3 символа' if manufacturer !~ /\A[\p{Cyrillic} \w]{3,}\z/
    vans.each { |van| validate_van!(van, recur) }
    #TODO
    #Если инициатор проверки вагон прицепленный к поезду, то будет проверен поезд, но не маршрут и не станция
    #Нужен более глубокий анализ recur, например recur = {:train => true; :station=>false; :route => false}
    raise InvalidRoute, 'Если указан, маршрут должен быть валидным' unless route.nil? || recur || route.valid?(true)
    raise InvalidStation, 'Если указана, станция должна быть валидная' unless station.nil? || recur || station.valid?(true)
  end

  def valid?(recur = false)
    validate!(recur)
    true
  rescue
    false
  end

  def initialize(number, manufacturer = nil)
    @number = number
    @vans = []
    @speed = 0
    @manufacturer = manufacturer || 'NoName'
    validate!

    @@trains << self
  end

  def destroy
    @@trains.delete(self)
  end

  def set_station(new_station)
    if station != new_station
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
    stop if speed < 0
  end

  def stop
    self.speed = 0
  end

  def hook(new_van)
    raise InvalidVan, 'Вагон должен быть указан' unless new_van.kind_of? Van
    raise DifferentTypes, 'Тип поезда не соответсвует типу вагона' unless type == new_van.type
    raise VanDoubleHooked, 'Вагон нельзя прицепить дважды' if vans.include?(new_van)
    raise TrainMoving, 'Нельзя прицепить вагон во время движения поезда' unless speed == 0

    self.vans << new_van
    new_van.hook(self) unless new_van.train == self
  end

  def unhook(old_van)
    raise VanNotHooked, 'Вагон не был прицеплен' unless vans.include?(old_van) 
    raise TrainMoving, 'Нельзя отцепить вагон во время движения поезда' unless speed == 0
    vans.delete(old_van)
    old_van.unhook if old_van.train == self
  end

  def set_route(new_route)
    self.route = new_route
    set_station(new_route.stations.first) if new_route
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

  def vans_info
    vans.each { |van| yield(van) }
  end

  def to_s_simple
    "\##{number} #{type} #{vans.count}"
  end

  private
  attr_writer :vans, :speed, :route, :station

end
  