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

  def take_seat
    self.seats[:used] += 1 if self.seats[:used] < self.seats[:total]
  end

  def to_s
    super + " мест (#{self.seats[:used]}/#{self.seats[:total]})"
  end

  private
  attr_writer :seats
end
