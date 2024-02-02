=begin
 
Содержит инстанс-метод validate!, который запускает все проверки (валидации), указанные в классе через метод класса validate. В случае ошибки валидации выбрасывает исключение с сообщением о том, какая именно валидация не прошла
Содержит инстанс-метод valid? который возвращает true, если все проверки валидации прошли успешно и false, если есть ошибки валидации.

=end

module Validation
  ValidateFail = Class.new(StandardError)
  PresenceValidateFail = Class.new(ValidateFail)
  FormatValidateFail = Class.new(ValidateFail)
  TypeValidateFail= Class.new(ValidateFail)

  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end

 # Методы класса
  module ClassMethods
    def validations
      @validations ||= []
    end

    def validate(name, mode, option = nil)
      raise TypeError, "[name] должно быть Symbol" unless name.kind_of?(Symbol)
      raise TypeError, "[mode] должно быть Symbol" unless mode.kind_of?(Symbol)
      
      case mode
      when :presence
        method_name = "validate_#{name}_prescence"
        method_proc = define_method(method_name) do
          var = self.public_send(name)
          raise PresenceValidateFail, "#{name} не может быть nil" if var.nil?
          raise PresenceValidateFail, "#{name} не может быть ''" if var.kind_of?(String) && var.empty?
        end
        validations.push(method_proc)

      when :format
        method_name = "validate_#{name}_format"
        raise ArgumentError, "[option] в режиме :format должно быть Regexp" unless option.kind_of?(Regexp)
        method_proc = define_method(method_name) do
          var = self.public_send(name)
          raise TypeError, "#{name} не строка, формат может быть проверен только у строки" unless var.kind_of?(String) 
          raise FormatValidateFail, "#{name} не соответсвует формату #{option.inspect}" if var !~ option
        end
        validations.push(method_proc)

      when :type
        method_name = "validate_#{name}_type"
        raise ArgumentError, "[option] в режиме :type должно быть Class" unless option.kind_of?(Class)
        method_proc = define_method(method_name) do
          var = self.public_send(name)
          raise TypeValidateFail, "#{name} имеет тип #{var.class}, а должен быть #{option}" unless var.kind_of?(option)
        end
        validations.push(method_proc)

      else
        raise ArgumentError, "[mode] имеет не изветное значение" 
      end
    end

  end

  # Методы сущности
  module InstanceMethods
    def validate!
      self.class.validations.each do |val|
        method(val).call
      end
    end

    def valid?
      validate!
      true
    rescue ValidateFail
      false
    end
  end

end
