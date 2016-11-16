# encoding: utf-8

module AttributesAccessor
 
  def self.included(base)
    element_variables = "@@class_attributes_elements"
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
          instance_variable_set(_v,data["#{element}"].nil? ? nil : data["#{element}"].send(_method)) unless base.instance_variable_defined?(_v)
        end
        instance_variable_get(_v)
      end

      if _method == :to_bool
        base.send(:define_method,"#{_un}?") do
          eval(_un)
        end
      end

    end


    base.send(:define_method,"to_hash") do |options = {}|
#      _l = Logging.logger[self]
#      _l.debug "#{options}"
      _exclude = options[:exclude] || []
      unless _exclude.kind_of? Array
        _exclude = [_exclude]
      end

      if self.respond_to?(:extra_hash)
        _e = extra_hash options
      else
        _e = {}
      end
      if base.superclass.instance_methods.include?(:to_hash)
        _s = super(options)
      else
        _s = {}
      end
      _el = elements.map{|element| element.underscore}
      _s.merge(Hash[*(_el.select{|element| !_exclude.include?(element.to_sym)}.map{ |element| [element.to_sym,eval(element)] }).flatten ].merge(_e))
    end
  end

end
