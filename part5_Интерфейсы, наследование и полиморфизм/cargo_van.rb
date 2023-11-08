require_relative 'van.rb'
class CargoVan < Van
  def initialize(number, type = :cargo)
    raise 'Класс CargoVan должен иметь тип :cargo' if type != :cargo
    super(number, type)
  end
end