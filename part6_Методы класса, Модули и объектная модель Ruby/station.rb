class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
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
