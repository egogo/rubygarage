class Module
  
  def attribute(*params, &block)
    if params.first.is_a? Hash
      params.first.each {|n,d| define_attr n,d }
    else
      define_attr *params, &block
    end
  end
  
  private
  
  def define_attr(name, default = nil, &block)
    
    define_method "#{name}?" do
      !!send("#{name}")
    end
    
    define_method name do
      return instance_variable_get("@#{name}_val") if instance_variable_defined?("@#{name}_val")
      send "#{name}=", (block ? instance_eval(&block) : default)
    end
    
    define_method "#{name}=" do |v|
      instance_variable_set("@#{name}_val", v)
    end
    
  end

end