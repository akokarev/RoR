require_relative 'modules/instance_counter.rb'
class Station
  include InstanceCounter
  attr_reader :name, :trains

  @@stations = []

  def self.all
    @@stations.clone
  end

  def destroy
    self.trains.each { |train| 
                        if train.route.nil?
                          self.depart(train)
                        else
                          train.move_up
                          train.move_down if train.station == self
                          self.depart(train) if train.station == self
                        end
                      }
    @@stations.delete(self)
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    register_instance
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

  private 
  attr_writer :trains

end
