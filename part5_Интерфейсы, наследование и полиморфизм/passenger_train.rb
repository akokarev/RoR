require_relative 'train.rb'
class PassengerTrain < Train
  def initialize(number, type = :passenger)
    raise 'Класс PassengerTrain должен иметь тип :passenger' if type != :passenger
    super(number, type)
  end
end