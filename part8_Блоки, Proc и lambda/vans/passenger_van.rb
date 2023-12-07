require_relative 'van.rb'
class PassengerVan < Van
  attr_reader :seats

  def type 
    :passenger
  end  

  def initialize(number, manufacturer = nil, seats_count)
    raise "Количество мест должно быть указано" if seats_count.nil?
    @seats = {:total => seats_count, :used => 0 }
    super(number, manufacturer)
  end

  def free_seats
    self.seats[:total] - self.seats[:used]
  end

  def take_seats(seats_add = 1)
    can_be_added = (self.free_seats > seats_add) ? seats_add : self.free_seats
    self.seats[:used] += can_be_added
    [can_be_added, seats_add - can_be_added]
  end

  def to_s
    super + " мест (#{self.seats[:used]}/#{self.seats[:total]})"
  end

  def to_s_simple
    super + " #{self.seats[:used]}/#{self.seats[:total]}"
  end

  private
  attr_writer :seats
end
