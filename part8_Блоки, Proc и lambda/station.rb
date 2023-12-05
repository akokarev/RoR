require_relative 'modules/instance_counter.rb'
require_relative 'trains/train.rb'
class Station
  include InstanceCounter
  attr_reader :name, :trains

  @@stations = []

  def self.all
    @@stations.clone
  end

  def validate!(recur=false)
#    raise 'Название станции должно быть строка' unless self.name.kind_of? String
#    raise 'Название станции не может быть пустым' if self.name.length == 0
    raise 'Название станции должно состоять из русских и английских букв, цифр' if self.name !~ /\A[\p{Cyrillic} \w]+\z/

    self.trains.each do |train| 
      raise "Поезда должны происходить от Train: #{train.inspect}" unless train.class.ancestors.include? Train
      raise "Поезда на станции должны быть валидными" unless recur || train.valid?(true)
    end
  end

  def valid?(recur = false)
    validate!(recur)
    true
  rescue
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
    self.trains.each do |train| 
                        if train.route.nil?
                          self.depart(train)
                        else
                          train.move_up
                          train.move_down if train.station == self
                          self.depart(train) if train.station == self
                        end
                      end
    @@stations.delete(self)
  end

  def arrive(new_train)
    self.trains << new_train
    new_train.set_station(self) unless new_train.station == self
  end

  def depart(old_train)
    self.trains.delete(old_train)
    old_train.set_station(nil) if old_train.station == self
  end

  def by_type(type)
    self.trains.select {|t| t.type == type}
  end

  def to_s
    self.name
  end

  def each
    self.trains.each { |train| yield(train) }
  end

  private 
  attr_writer :trains

end
