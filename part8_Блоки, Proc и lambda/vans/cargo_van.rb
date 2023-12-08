require_relative 'van.rb'
class CargoVan < Van
  attr_reader :volume

  def type 
    :cargo
  end  

  def initialize(number, manufacturer = nil, volume_new)
    raise "Объем должен быть указан" if volume_new.nil?
    @volume = {:total => volume_new, :used => 0 }
    super(number, manufacturer)
  end

  def free_volume
    self.volume[:total] - self.volume[:used]
  end

  def used_volume
    self.volume[:used]
  end

  def total_volume
    self.volume[:total]
  end

  def take_volume(volume_add)
    if self.free_volume >= volume_add
      self.volume[:used] += volume_add
    else
      raise 'Недостаточно свободного объема в вагоне'
    end
  end

  private
  attr_writer :volume
end
