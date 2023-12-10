require_relative '../trains/train.rb'
require_relative '../modules/manufacturer.rb'
require_relative '../exceptions.rb'
class Van
  include Manufacturer
  attr_reader :number, :train

  def type 
    raise NotImplementedError
  end

  def validate_train!(train, recur = false)
    unless train.nil?
      raise TypeError, 'Поезд должен быть наследником класса Train' unless train.kind_of? Train
      raise DifferentTypes, 'Тип вагона не соответсвует типу поезда' unless type == train.type
      raise InvalidTrain, 'Поезд должен быть валидным' unless recur || train.valid?(true)
    end
  end

  def validate!(recur = false)
    raise WrongVanNumber, 'Номер вагона целое число больше нуля' unless number.kind_of?(Integer) && number > 0
    raise WrongManufaturer, 'Производитель строка минимум 3 символа' if manufacturer !~ /\A[\p{Cyrillic} \w]{3,}\z/
    validate_train!(train, recur)
  end

  def valid?(recur = false)
    validate!(recur)
    true
  rescue
    false
  end

  def initialize(number, manufacturer = nil)
    @number = number
    @train = nil
    @manufacturer = manufacturer || 'NoName'
    validate!
  end

  def hook(new_train)
    validate_train!(new_train)
    raise VanDoubleHooked, 'Вагон нельзя прицепить дважды' unless train.nil?
    raise TrainMoving, 'Нельзя прицепить вагон во время движения поезда' unless new_train.speed == 0

    self.train = new_train
    train.hook(self) unless train.vans.include?(self)
  end

  def unhook
    raise VanNotHooked, 'Нельзя отцепить отцепленный вагон' if train == nil
    raise TrainMoving, 'Нельзя отцепить вагон во время движения поезда' unless train.speed == 0
    old_train = train
    self.train = nil
    old_train.unhook(self) if old_train.vans.include?(self)
  end

  private
  attr_writer :train
end
