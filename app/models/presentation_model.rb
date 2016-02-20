class PresentationModel

  # Generic initialization method to init Instances with every instance attribute
  def initialize(*h)
    if h.length == 1 && h.first.kind_of?(Hash)
      h.first.each { |k,v| send("#{k}=",v) }
    end
  end

  def data= _data
    @data = _data
  end

  def data
    @data
  end

end