require_relative 'van.rb'
class PassengerVan < Van
  attr_reader :seats

  def type 
    :passenger
  end  

  def initialize(number, manufacturer = nil, seats_count)
    raise "Количество мест должно быть указано" if seats_count.nil?
    @seats = {total: seats_count, used: 0 }
    super(number, manufacturer)
  end

  def free_seats
    self.seats[:total] - self.seats[:used]
  end

  def used_seats
    self.seats[:used]
  end

  def total_seats
    self.seats[:total]
  end

  def take_seat
    if self.free_seats >= 1
      self.seats[:used] += 1
    else
      raise 'Нет свободных мест'
    end
  end

  private
  attr_writer :seats
end
