require 'ostruct'

class PresentationModel < OpenStruct

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