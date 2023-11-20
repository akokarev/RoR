class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def arrive(train)
    trains << train
    train.set_station(self) if train.current_station != self
  end

  def depart(train)
    trains.delete(train)
    train.set_station(nil) if train.current_station == self
  end

  def by_type(type)
    trains.select {|t| t.type == type}
  end

  def to_s
    name
  end

private 
attr_writer :trains

end
