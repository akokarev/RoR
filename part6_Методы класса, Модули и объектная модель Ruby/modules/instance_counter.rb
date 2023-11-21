module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
    @@instances = 0
  end  

  module ClassMethods
    def instances
      @@instances
    end
  end

  module InstanceMethods
    protected
    def register_instance
      @@instances += 1
    end

    def unregister_instance
      @@instances -= 1
    end
  end

end
