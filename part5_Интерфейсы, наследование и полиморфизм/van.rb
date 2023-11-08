require_relative 'train.rb'
class Van
  attr_reader :number, :type, :train
  private attr_writer :number, :type, :train

  def initialize(number, type)
    @number = number
    @type = type
    @train = nil
  end

  def hook(train)
    raise 'Поезд должен быть указан' unless train.kind_of? Train
    raise 'Тип вагона не соответсвует типу поезда' unless self.type == train.type  
    raise 'Вагон нельзя прицепить дважды' unless @train == nil
    raise 'Нельзя прицепить вагон во время движения поезда' unless train.speed == 0
    @train = train
    train.hook(self) unless train.vans.include?(self)
  end

  def unhook
    raise 'Нельзя отцепить отцепленный вагон' if train == nil
    raise 'Нельзя отцепить вагон во время движения поезда' unless train.speed == 0
    old_train = train
    train = nil
    old_train.unhook(self) if old_train.vans.include?(self)
  end
end