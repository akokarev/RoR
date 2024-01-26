# Модуль добавляет счетчик сущностей
module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
    base.send(:instances=, 0)
  end

  # Методы класса
  module ClassMethods
    attr_reader :instances

    private

    attr_writer :instances
  end

  # Методы сущности
  module InstanceMethods
    protected

    def register_instance
      self.class.send(:instances=, self.class.instances + 1)
    end
  end
end
