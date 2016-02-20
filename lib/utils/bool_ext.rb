class String
  def to_bool
    return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end

  def integer?
    !(Integer(self) rescue nil).nil?
  end

end

class TrueClass
  def to_bool
    true
  end
end

class FalseClass
  def to_bool
    false
  end
end

class Fixnum
  def to_bool
    self == 1
  end
end

class NilClass
  def to_bool
    false
  end
end
