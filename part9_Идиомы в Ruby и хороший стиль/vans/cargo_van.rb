require_relative 'van'
require_relative '../exceptions'
class CargoVan < Van
  attr_reader :volume

  def type
    :cargo
  end

  def initialize(number, manufacturer = nil, volume_new)
    raise ArgumentError, 'Объем должен быть указан' if volume_new.nil?

    @volume = { total: volume_new, used: 0 }
    super(number, manufacturer)
  end

  def free_volume
    volume[:total] - volume[:used]
  end

  def used_volume
    volume[:used]
  end

  def total_volume
    volume[:total]
  end

  def take_volume(volume_add)
    raise NotEnoughFreeVolume, 'Нет свободного места' if free_volume <= volume_add

    volume[:used] += volume_add
  end

  private

  attr_writer :volume
end
