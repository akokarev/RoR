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

  def take_volume(volume_add)
    can_be_added = (self.free_volume > volume_add) ? volume_add : self.free_volume
    self.volume[:used] += can_be_added
    [can_be_added, volume_add - can_be_added]
  end

  def to_s
    super + " объем (#{self.volume[:used]}/#{self.volume[:total]})"
  end

  def to_s_simple
    super + " #{self.volume[:used]}/#{self.volume[:total]}"
  end

  private
  attr_writer :volume
end
