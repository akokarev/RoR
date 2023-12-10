require_relative 'van.rb'
require_relative '../exceptions.rb'
class PassengerVan < Van
  attr_reader :seats

  def type 
    :passenger
  end

  def initialize(number, manufacturer = nil, seats_count)
    raise ArgumentError, "Количество мест должно быть указано" if seats_count.nil?
    @seats = {total: seats_count, used: 0 }
    super(number, manufacturer)
  end

  def free_seats
    seats[:total] - seats[:used]
  end

  def used_seats
    seats[:used]
  end

  def total_seats
    seats[:total]
  end

  def take_seat
    raise NotEnoughFreeSeats, 'Нет свободных мест' if free_seats == 0
    self.seats[:used] += 1
  end

  private
  attr_writer :seats
end
