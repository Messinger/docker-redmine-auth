# encoding: utf-8

module AttributesAccessor
 
  def self.included(base)
    element_variables = "@@#{base.name.underscore}_elements"    
    _elements = base.class_variable_get(element_variables)
    elements = []
    _elements.each do |_element|
      _e = _element.split(':')
      element = _e[0]

      _method = nil

      if _e.count > 1
        _method = if _e[1] == "bool"
                    :to_bool
                  elsif _e[1] == "int"
                    :to_i
                  else
                    nil
                  end
      end
      elements << _e[0]
      _un = element.underscore
      _v = "@#{_un}"
      base.send(:define_method,_un) do
        if _method.nil?
          instance_variable_set(_v,data["#{element}"].blank? ? nil : data["#{element}"]) unless base.instance_variable_defined?(_v)
        else
          instance_variable_set(_v,data["#{element}"].blank? ? nil : data["#{element}"].send(_method)) unless base.instance_variable_defined?(_v)
        end
        instance_variable_get(_v)
      end

      if _method == :to_bool
        base.send(:define_method,"#{_un}?") do
          eval(_un)
        end
      end

    end


    base.send(:define_method,"to_hash") do
      if self.respond_to?(:extra_hash)
        _e = extra_hash
      else
        _e = {}
      end
      if base.superclass.instance_methods.include?(:to_hash)
        _s = super()
      else
        _s = {}
      end
      _s.merge(Hash[*(elements.map{ |element| [element.underscore.to_sym,eval(element.underscore)] }).flatten ].merge(_e))
    end
  end

end
