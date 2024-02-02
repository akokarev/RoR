  module Acсessors
  def attr_accessor_with_history(*variables)
    variables.each do |variable|
      raise TypeError.new("variable name is not symbol") unless variable.is_a?(Symbol)
      history = "#{variable}_history"
      var_history = "@#{history}"
      
      define_method(history) do
        instance_variable_get(var_history) || instance_variable_set(var_history, [])
      end

      define_method(variable) do
        self.public_send(history).last
      end
      
      define_method("#{variable}=") do |v|
        self.public_send(history).push(v)
      end
    end
  end

  def strong_attr_accessor(variable, type)
    define_method("#{variable}") do
      instance_variable_get("@#{variable}")
    end

    define_method("#{variable}=") do |v|
      raise TypeError, "Type of #{variable} is #{v.class}, but shuld be #{type}" unless v.kind_of?(type)
      instance_variable_set("@#{variable}", v)
    end

  end
end
