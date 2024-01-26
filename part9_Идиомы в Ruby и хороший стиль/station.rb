require_relative 'modules/instance_counter'
require_relative 'trains/train'
# Класс железнодорожных станций
class Station
  include InstanceCounter
  attr_reader :name, :trains

  @@stations = []

  def self.all
    @@stations.clone
  end

  def validate!(recur: false)
    #    raise 'Название станции должно быть строка' unless self.name.kind_of? String
    #    raise 'Название станции не может быть пустым' if self.name.length == 0
    if name !~ /\A[\p{Cyrillic} \w]+\z/
      raise InvalidStationName,
            'Название станции должно состоять из русских и английских букв, цифр'
    end

    trains.each do |train|
      raise TypeError, 'Поезда должны происходить от Train' unless train.class.ancestors.include? Train
      raise InvalidTrain, 'Поезда на станции должны быть валидными' unless recur || train.valid?(recur: true)
    end
  end

  def valid?(recur: false)
    validate!(recur: recur)
    true
  rescue StandardError
    false
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!

    @@stations << self
    register_instance
  end

  def destroy
    trains.each do |train|
      if train.route.nil?
        depart(train)
      else
        train.move_up
        train.move_down if train.station == self
        depart(train) if train.station == self
      end
    end
    @@stations.delete(self)
  end

  def arrive(new_train)
    trains << new_train
    new_train.move_station(self) unless new_train.station == self
  end

  def depart(old_train)
    trains.delete(old_train)
    old_train.move_station(nil) if old_train.station == self
  end

  def by_type(type)
    trains.select { |t| t.type == type }
  end

  def trains_info(&block)
    trains.each(&block)
  end

  private

  attr_writer :trains
end
