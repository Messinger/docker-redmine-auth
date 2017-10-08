require 'ostruct'

class PresentationModel < OpenStruct

  def initialize(hash=nil)
    super hash
    if hash
      hash.each_pair do |k, v|
        if v.is_a?(Hash)
          k = k.to_sym
          @table[k] = PresentationModel.new(v)
        end
      end
    end
  end

  def to_hash options = nil
    if self.respond_to?(:extra_hash)
      _e = extra_hash options
    else
      _e = {}
    end

    _i = instance_values.as_json(options)
    _i.merge _e

  end

  def data
    self.to_h
  end

end