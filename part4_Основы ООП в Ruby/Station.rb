class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def arrive(train)
    trains << train
    train.station = self
  end

  def depart(train)
    @trains.delete(train)
  end

  def by_type(type)
    trains.select {|t| t.type == type}
  end
end