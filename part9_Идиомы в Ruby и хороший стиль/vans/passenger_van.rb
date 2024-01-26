require_relative 'van'
require_relative '../exceptions'
# Пассажирский вагон
class PassengerVan < Van
  attr_reader :seats

  def type
    :passenger
  end

  def initialize(number, seats_count, manufacturer = nil)
    raise ArgumentError, 'Количество мест должно быть указано' if seats_count.nil?

    @seats = { total: seats_count, used: 0 }
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
    raise NotEnoughFreeSeats, 'Нет свободных мест' if free_seats.zero?

    seats[:used] += 1
  end

  private

  attr_writer :seats
end
