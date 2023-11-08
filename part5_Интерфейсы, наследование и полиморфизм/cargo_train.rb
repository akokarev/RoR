require_relative 'train.rb'
class CargoTrain < Train
  def initialize(number, type = :cargo)
    raise 'Класс CargoTrain должен иметь тип :cargo' if type != :cargo
    super(number, type)
  end
end
