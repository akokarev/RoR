require_relative 'van.rb'
class PassengerVan < Van
  def initialize(number, type = :passenger)
    raise 'Класс PassengerVan должен иметь тип :passenger' if type != :passenger
    super(number, type)
  end
end