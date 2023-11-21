require_relative '../trains/train.rb'
class Van
  attr_reader :number, :train

  def type 
    raise NotImplementedError
  end

  def initialize(number)
    @number = number
    @train = nil
  end

  def hook(new_train)
    raise 'Поезд должен быть указан' unless new_train.kind_of? Train
    raise 'Тип вагона не соответсвует типу поезда' unless self.type == new_train.type  
    raise 'Вагон нельзя прицепить дважды' unless self.train.nil?
    raise 'Нельзя прицепить вагон во время движения поезда' unless new_train.speed == 0
    self.train = new_train
    self.train.hook(self) unless self.train.vans.include?(self)
  end

  def unhook
    raise 'Нельзя отцепить отцепленный вагон' if self.train == nil
    raise 'Нельзя отцепить вагон во время движения поезда' unless self.train.speed == 0
    old_train = self.train
    self.train = nil
    old_train.unhook(self) if old_train.vans.include?(self)
  end

  def to_s
    "Вагон #{self.number} #{self.type} #{self.train.nil? ? 'отцеплен' : self.train.number}"
  end

private
attr_writer :train

end
