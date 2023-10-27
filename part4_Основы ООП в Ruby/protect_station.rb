class Protect_station
  attr_reader :station

  protected
  def station= (station)
    @station = station
  end
end
