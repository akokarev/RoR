require_relative '../vans/van'
require_relative '../modules/manufacturer'
require_relative '../exceptions'
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
    raise TypeError, 'Вагон должен быть наследником класса Van' unless van.is_a? Van
    raise DifferentTypes, 'Тип вагона не соответсвует типу поезда' unless type == van.type
    raise InvalidVan, 'Вагон должен быть валидным' unless recur || van.valid?(true)
  end

  def validate!(recur = false)
    if number !~ /\A[\w\p{Cyrillic}]{3}(-[\w\p{Cyrillic}]{2}){0,1}\z/
      raise InvalidTrainNumber,
            'Номер поезда должен быть в формате 1ЯZ-2X'
    end
    raise InvalidManufacturer, 'Производитель строка минимум 3 символа' if manufacturer !~ /\A[\p{Cyrillic} \w]{3,}\z/

    vans.each { |van| validate_van!(van, recur) }
    # TODO
    # Если инициатор проверки вагон прицепленный к поезду, то будет проверен поезд, но не маршрут и не станция
    # Нужен более глубокий анализ recur, например recur = {:train => true; :station=>false; :route => false}
    raise InvalidRoute, 'Если указан, маршрут должен быть валидным' unless route.nil? || recur || route.valid?(true)

    return if station.nil? || recur || station.valid?(true)

    raise InvalidStation,
          'Если указана, станция должна быть валидная'
  end

  def valid?(recur = false)
    validate!(recur)
    true
  rescue StandardError
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
    return unless station != new_station

    old_station = station
    self.station = new_station
    old_station&.depart(self)
    new_station&.arrive(self)
  end

  def accelerate(delta_speed)
    self.speed += delta_speed if delta_speed.positive?
  end

  def slow(delta_speed)
    self.speed -= delta_speed if delta_speed.positive?
    stop if speed.negative?
  end

  def stop
    self.speed = 0
  end

  def hook(new_van)
    raise InvalidVan, 'Вагон должен быть указан' unless new_van.is_a? Van
    raise DifferentTypes, 'Тип поезда не соответсвует типу вагона' unless type == new_van.type
    raise VanDoubleHooked, 'Вагон нельзя прицепить дважды' if vans.include?(new_van)
    raise TrainMoving, 'Нельзя прицепить вагон во время движения поезда' unless speed.zero?

    vans << new_van
    new_van.hook(self) unless new_van.train == self
  end

  def unhook(old_van)
    raise VanNotHooked, 'Вагон не был прицеплен' unless vans.include?(old_van)
    raise TrainMoving, 'Нельзя отцепить вагон во время движения поезда' unless speed.zero?

    vans.delete(old_van)
    old_van.unhook if old_van.train == self
  end

  def set_route(new_route)
    self.route = new_route
    set_station(new_route.stations.first) if new_route
  end

  def move_up
    return unless route && station != route.stations.last

    set_station(next_station)
  end

  def move_down
    return unless route && station != route.stations.first

    set_station(prev_station)
  end

  def next_station
    route.stations[route.stations.index(station) + 1]
  end

  def prev_station
    route.stations[route.stations.index(station) - 1]
  end

  def vans_info(&block)
    vans.each(&block)
  end

  def to_s_simple
    "\##{number} #{type} #{vans.count}"
  end

  private

  attr_writer :vans, :speed, :route, :station
end
