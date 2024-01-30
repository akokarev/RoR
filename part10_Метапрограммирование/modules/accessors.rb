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
        instance_variable_get(var_history).push(v)
      end

    end
  end
end

class Test
  extend Acсessors

  attr_accessor_with_history :a, :b
end
