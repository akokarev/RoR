#require_relative 'modules/instance_counter'
#require_relative 'trains/train'
require_relative 'modules/validation'
# Класс железнодорожных станций
class Station
  #include InstanceCounter
  include Validation
  attr_reader :name, :trains

  validate :name, :type, String
  validate :name, :presence
  validate :name, :format, /\A[\p{Cyrillic} \w]+\z/
  @@stations = []

  def self.all
    @@stations.clone
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!

    @@stations << self
    #register_instance
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
